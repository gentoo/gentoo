# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="9780596005900"

DESCRIPTION="Howto write linux device drivers (updated for Linux 2.6)"
HOMEPAGE="
	https://www.oreilly.com/catalog/linuxdrive3/
	https://lwn.net/Kernel/LDD3/
"
SRC_URI="
	https://resources.oreilly.com/examples/${EGIT_COMMIT}/-/blob/master/examples.tar.gz -> LDD3-examples.tar.gz
	https://lwn.net/images/pdf/LDD3/ldd3_pdf.tar.bz2
"
S="${WORKDIR}"

LICENSE="CC-BY-SA-2.0"
SLOT="3"
KEYWORDS="amd64 arm ~hppa ppc ~riscv ~s390 x86"

src_install() {
	dodoc ldd3_pdf/*.pdf
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}
}
