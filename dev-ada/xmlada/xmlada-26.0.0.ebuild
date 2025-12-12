# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{12..16} )
PYTHON_COMPAT=( python3_{10..14} pypy3{,_11} )
inherit ada python-any-r1 multiprocessing

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="https://github.com/AdaCore/xmlada"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	')
)"

PATCHES=(
	"${FILESDIR}"/${PN}-23.0.0-gentoo.patch
	"${FILESDIR}"/${PN}-24.0.0-gentoo.patch
)

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	sed -i \
		-e "s|@PF@|${PF}|g" \
		input_sources/xmlada_input.gpr \
		|| die
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
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
	use doc && emake -C docs html
}

src_test() {
	GPR_PROJECT_PATH=schema:input_sources:dom:sax:unicode \
	gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=static \
		-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
		-XTESTS_ACTIVATED=Only \
		-largs ${LDFLAGS} \
		-cargs ${ADAFLAGS} || die "gprbuild failed"
	emake --no-print-directory -C tests tests | tee xmlada.testLog
	grep -q DIFF xmlada.testLog && die
	rm docs/*/b__* || die
	rm docs/*/*ali || die
	rm docs/*/*std* || die
	rm docs/*/*bexch || die
	rm docs/*/*.o || die
	rm docs/*/*example || die
	rm docs/dom/domexample2 || die
	rm docs/sax/saxexample_main || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -XBUILD=Production \
			-XPROCESSORS=$(makeopts_jobs) --prefix="${D}"/usr \
			--install-name=xmlada --build-var=LIBRARY_TYPE \
			--build-var=XMLADA_BUILD \
			--build-name=$1 xmlada.gpr || die "gprinstall failed"
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
	einstalldocs
	rm -r "${D}"/usr/share/gpr/manifests
}
