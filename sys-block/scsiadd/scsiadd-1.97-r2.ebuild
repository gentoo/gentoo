# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Add and remove SCSI devices from your Linux system during runtime"
HOMEPAGE="https://llg.cubic.org/tools/"
SRC_URI="https://llg.cubic.org/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="suid"

RDEPEND="suid? ( acct-group/scsi )"
BDEPEND="${RDEPEND}"

src_prepare() {
	default

	# Remove 'strip' command, as portage handles this
	sed -e "s:^\(.*strip.*\):#\1:g" -i Makefile.in || die

	# Convert docs to UTF-8
	if [ -x "$(type -p iconv)" ]; then
		for X in NEWS README; do
			iconv -f LATIN1 -t UTF8 -o "${X}~" "${X}" \
				&& mv -f "${X}~" "${X}" \
				|| rm -f "${X}~" || die
		done
	fi
}

src_compile() {
	# Extra safety for suid
	append-ldflags -Wl,-z,now

	# Use system compiler
	tc-export CC

	default
}

src_install() {
	dosbin scsiadd

	if use suid; then
		fowners root:scsi /usr/sbin/scsiadd
		fperms 4710 /usr/sbin/scsiadd
	fi

	doman scsiadd.8

	einstalldocs
}

pkg_postinst() {
	if use suid; then
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
	fi
}
