# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Network performance measurement tool"
HOMEPAGE="https://www.nuttcp.net/"
SRC_URI="https://nuttcp.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xinetd"

RDEPEND="xinetd? ( sys-apps/xinetd )"

DOCS=( examples.txt README )
# Honor CC, LDFLAGS, CFLAGS, CPPFLAGS
PATCHES=( "${FILESDIR}"/"${P}"-makefile.patch )

DOC_CONTENTS="Usage of nuttpc by its service name in xinetd service,
iptables rules, etc. will require adding these lines to /etc/services:\\n
nuttcp\\t\\t5000/tcp\\n
nuttcp-data\\t\\t5001/tcp\\n
nuttcp6\\t\\t5000/tcp\\n
nuttcp6-data\\t\\t5001/tcp\\n\\n
To run ${PN} in server mode, run:\\n/etc/init.d/${PN} start"

src_prepare() {
	default

	# Fix path to binary
	sed -i '/server/s|/local||' xinetd.d/nuttcp || die "sed failed"
}

src_compile() {
	emake APPEXT='' CC="$(tc-getCC)"
}

src_install() {
	einstalldocs
	doman "${PN}".8
	newbin "${P}" "${PN}"

	newinitd "${FILESDIR}"/"${PN}".initd "${PN}"
	newconfd "${FILESDIR}"/"${PN}".confd "${PN}"
	systemd_dounit systemd/"${PN}"@.service
	systemd_dounit systemd/"${PN}".socket

	if use xinetd ; then
		insinto /etc/xinetd.d
		doins xinetd.d/"${PN}"
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
