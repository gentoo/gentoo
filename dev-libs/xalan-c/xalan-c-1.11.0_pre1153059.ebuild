# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="XSLT processor for transforming XML into HTML, text, or other XML types"
HOMEPAGE="https://xml.apache.org/xalan-c/"
SRC_URI="mirror://gentoo/Xalan-C_r${PV#*_pre}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples nls threads"

RDEPEND=">=dev-libs/xerces-c-2.8.0"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/xml-xalan/c"

PATCHES=(
	"${FILESDIR}"/1.11.0_pre797991-as-needed.patch
	"${FILESDIR}"/1.11.0_pre797991-bugfixes.patch
	"${FILESDIR}"/1.11.0_pre797991-parallel-build.patch
)

src_prepare() {
	default

	# - do not run configure in runConfigure
	# - echo the export commands instead exporting the vars
	# - remove -O3
	# - make sure our {C,CXX}FLAGS get respected
	sed -i \
		-e '/\/configure/d' \
		-e 's/^export \([a-zA-Z_]*\)/echo export \1=\\"$\1\\"/' \
		-e 's/\(debugflag\)="-O.\? /\1="/' \
		-e 's/^\(CXXFLAGS\)="$compileroptions/\1="${\1}/' \
		-e 's/^\(CFLAGS\)="$compileroptions/\1="${\1}/' \
		runConfigure || die "sed failed"
}

src_configure() {
	export XERCESCROOT="/usr"
	export XALANCROOT="${S}"

	local target="linux"
	local transcoder="default"
	local mloader=$(usex nls nls inmem)
	local thread=$(usex threads pthread none)

	./runConfigure -p ${target} -c "$(tc-getCC)" -x "$(tc-getCXX)" \
		-m ${mloader} -t ${transcoder} \
		-r ${thread} > configure.vars || die "runConfigure failed"

	eval $(grep export configure.vars)

	default
}

src_compile() {
	default

	if use doc; then
		mkdir build || die
		cd xdocs || die
		doxygen DoxyfileXalan || die
		HTML_DOCS=( build/docs/apiDocs/. )

		# clean doxygen cruft
		find "${S}"/build \( -iname '*.map' -o -iname '*.md5' \) -delete || die
	fi
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc -r samples/.
	fi
}

pkg_postinst() {
	ewarn "If you are upgrading you should run"
	ewarn "    revdep-rebuild --library=libxalan-c.so.110"
	ewarn "if using portage or"
	ewarn "    reconcilio --library libxalan-c.so.110"
	ewarn "if using paludis as your package manager."
}
