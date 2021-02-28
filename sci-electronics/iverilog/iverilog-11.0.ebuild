# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

GITHUB_PV=$(ver_rs 1- '_')

DESCRIPTION="A Verilog simulation and synthesis tool"
HOMEPAGE="
	http://iverilog.icarus.com
	https://github.com/steveicarus/iverilog
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/steveicarus/${PN}.git"
else
	SRC_URI="https://github.com/steveicarus/${PN}/archive/v${GITHUB_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
	S="${WORKDIR}/${PN}-${GITHUB_PV}"
fi

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="
	sys-libs/readline:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${FILESDIR}/${P}-autoconf-2.70.patch" #749870
)

src_prepare() {
	default

	# From upstreams autoconf.sh, to make it utilize the autotools eclass
	# Here translate the autoconf.sh, equivalent to the following code
	# > sh autoconf.sh

	# Autoconf in root ...
	eautoconf

	# Precompiling lexor_keyword.gperf
	gperf -o -i 7 -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf > lexor_keyword.cc || die
	# Precompiling vhdlpp/lexor_keyword.gperf
	cd vhdlpp || die
	gperf -o -i 7 --ignore-case -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf > lexor_keyword.cc || die
}

src_install() {
	local DOCS=( *.txt )

	default

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
