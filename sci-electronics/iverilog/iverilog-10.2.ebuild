# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Verilog simulation and synthesis tool"
SRC_URI="ftp://icarus.com/pub/eda/verilog/v${PV:0:2}/verilog-${PV}.tar.gz"
HOMEPAGE="http://iverilog.icarus.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="examples"

RDEPEND="
	app-arch/bzip2
	sys-libs/readline:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P#i}"

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	dodoc *.txt

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
