# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Change directory command that learns visited paths"
HOMEPAGE="https://github.com/rupa/z/"
SRC_URI="https://github.com/rupa/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/rupa-z-5dc2a86"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/${PN}/"
	doins z.sh
	doman z.1
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To enable 'z' command you need to source /usr/share/${PN}/z.sh."
		elog "Add following line to your ~/.bashrc, ~/.zshrc or equivalent"
		elog "in other shells:"
		elog ""
		elog "    [ -r /usr/share/${PN}/z.sh ] && . /usr/share/${PN}/z.sh"
		elog ""
		elog "See z(1) man page for usage and configuration options."
	fi
}
