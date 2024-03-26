# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="A high level string and text processing library"
HOMEPAGE="https://github.com/AdaCore/VSS"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada:=[shared?,static-libs?,static-pic?,${ADA_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]
	test? (
		app-i18n/unicode-data
	)"

src_prepare() {
	ln -sf /usr/share/unicode-data data/ucd || die
	default
}

src_compile() {
	build () {
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_gnat.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_text.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_json.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_regexp.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_xml.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -p -j$(makeopts_jobs) -v \
			gnat/vss_xml_templates.gpr \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -XVSS_LIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 -p \
			-j$(makeopts_jobs) -v gnat/vss_xml_xmlada.gpr \
			-cargs:Ada ${ADAFLAGS} || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

src_test() {
	emake -j1 GPRBUILD_FLAGS="-p -j$(makeopts_jobs) -v" build_tests
	# To run all the test need to follow data/README.md
	emake check_html
}

src_install() {
	build () {
		emake -j1 DESTDIR="${D}" install-libs-$1
	}
	use shared && build relocatable
	use static-libs && build static
	use static-pic && build static-pic
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
