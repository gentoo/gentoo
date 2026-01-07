# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{15..16} )
inherit ada multiprocessing

DESCRIPTION="A high level string and text processing library"
HOMEPAGE="https://github.com/AdaCore/vss-extra"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic test"
RESTRICT="test"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada:=[shared,static-libs?,static-pic?,${ADA_USEDEP}]
	dev-ada/vss-text:${SLOT}[static-libs?,static-pic?,${ADA_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	build () {
		for i in os json regexp xml xml_templates; do
			gprbuild -p -j$(makeopts_jobs) -v \
				-XVSS_BUILD_PROFILE=release \
				-XVSS_LIBRARY_TYPE=$1 \
				gnat/vss_${i}.gpr \
				-cargs:Ada ${ADAFLAGS} || die
		done
		gprbuild -p -j$(makeopts_jobs) -v \
			-XXMLADA_BUILD=$1 \
			-XVSS_BUILD_PROFILE=release \
			-XVSS_LIBRARY_TYPE=$1 \
			gnat/vss_xml_xmlada.gpr \
			-cargs:Ada ${ADAFLAGS} || die
	}
	build relocatable
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

src_test() {
	emake -j1 GPRFLAGS="-j$(makeopts_jobs) -v" build-tests
	# To run all the test need to follow data/README.md
	emake check_text
	emake check_json
	emake check_regexp
	emake check_html
}

src_install() {
	build () {
		emake -j1 DESTDIR="${D}" install-libs-release_$1
	}
	build relocatable
	use static-libs && build static
	use static-pic && build static-pic
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
