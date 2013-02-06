# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="Postfix srsd lookup service"
HOMEPAGE="https://github.com/Fruneau/pfixtools"

# The releases the project has made still need the libcommon git submodule
SRC_URI=""
EGIT_REPO_URI="git://github.com/Fruneau/pfixtools.git"
EGIT_HAS_SUBMODULES="yes"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="dev-libs/libev
			mail-filter/libsrs2"

src_compile() {
	# make pfix-srsd is not supported right now, bug filed at https://github.com/Fruneau/pfixtools/issues/5
	cd common
	emake || die
	cd ..

	cd pfix-srsd
	emake || die
	cd ..
}

src_install() {
	dodir /usr/sbin
	cd pfix-srsd
	einstall || die
	cd ..

	dodir /etc/postfix

	newinitd "${FILESDIR}/pfix-srsd.init" pfix-srsd
	newconfd "${FILESDIR}/pfix-srsd.confd" pfix-srsd

	dodoc AUTHORS ChangeLog INSTALL LICENSE README.asciidoc pfix-srsd/pfix-srsd.asciidoc

}

pkg_postinst() {
	einfo "You need to generate a secrets file (/etc/postfix/srs.secrets by default)"
	einfo "To do this, run"
	einfo "  dd if=/dev/urandom bs=18 count=1 | base64 > /etc/postfix/srs.secrets"
	einfo "Make sure to keep this file safe!"
}
