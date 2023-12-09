# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${GITHUB_PV}"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples"

# 721022, should depend on sys-libs/readline:=
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
	"${FILESDIR}"/${PN}-10.3-file-missing.patch #705412
	"${FILESDIR}"/${PN}-10.3-fno-common.patch #706366
	"${FILESDIR}"/${PN}-10.3-gen-bison-header.patch #734760
	"${FILESDIR}"/${PN}-10.3-call-nm.patch #731906
	"${FILESDIR}"/${PN}-10.3-configure-ac.patch #426262
	"${FILESDIR}"/${PN}-10.3-override-var.patch #730096
)

src_prepare() {
	default

	# From upstreams autoconf.sh, to make it utilize the autotools eclass
	# Here translate the autoconf.sh, equivalent to the following code
	# > sh autoconf.sh

	# Move configure.in to configure.ac (bug #426262)
	mv configure.in configure.ac || die

	# Autoconf in root ...
	eautoconf --force
	# Precompiling lexor_keyword.gperf
	gperf -o -i 7 -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf > lexor_keyword.cc || die
	# Precompiling vhdlpp/lexor_keyword.gperf
	cd vhdlpp || die
	gperf -o -i 7 --ignore-case -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf > lexor_keyword.cc || die
}

src_install() {
	local DOCS=( *.txt )
	# Default build fails with parallel jobs,
	# https://github.com/steveicarus/iverilog/pull/294
	emake installdirs DESTDIR="${D}"
	default

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
