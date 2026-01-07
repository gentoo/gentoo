# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
ADA_COMPAT=( gcc_{12..16} )

DISTUTILS_USE_PEP517=setuptools
inherit python-single-r1 ada multiprocessing

DESCRIPTION="A Python framework to generate language parsers - Contrib"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/langkit/archive/refs/tags/v${PV}.tar.gz
	-> langkit-${PV}.tar.gz
	https://github.com/AdaCore/AdaSAT/archive/refs/tags/v${PV}.tar.gz
	-> AdaSAT-${PV}.tar.gz"

S="${WORKDIR}"/langkit-${PV}

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	${ADA_DEPS}
	dev-ada/langkit:${SLOT}[${ADA_USEDEP},static-libs?,static-pic?]
	$(python_gen_cond_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')"
BDEPEND="${RDEPEND}
	dev-ada/e3-core
	$(python_gen_cond_dep '
		dev-ada/e3-core[${PYTHON_USEDEP}]
	')
	dev-ada/gprbuild[${ADA_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	local libtype=relocatable
	use static-libs && libtype+=',static'
	use static-pic && libtype+=',static-pic'
	GPR_PROJECT_PATH="${WORKDIR}"/AdaSAT-${PV} \
		${EPYTHON} manage.py make --no-mypy \
		--library-types=${libtype} \
		--no-langkit-support \
		--build-mode prod \
		--jobs $(makeopts_jobs) --gargs \\-v || die
}

src_install() {
	local libtype=relocatable
	use static-libs && libtype+=',static'
	use static-pic && libtype+=',static-pic'
	#${EPYTHON} manage.py install-langkit-support "${D}"/usr \
	#	--library-types=${libtype} || die
	GPR_PROJECT_PATH="${WORKDIR}"/AdaSAT-${PV} \
		${EPYTHON} -m langkit.scripts.lkm install -c lkt/langkit.yaml \
		--build-mode prod \
		"${D}"/usr --library-types=${libtype} --disable-all-mains || die
	python_domodule lkt/build/python/liblktlang
	rm -r "${D}"/usr/java || die
	rm -r "${D}"/usr/ocaml || die
	rm -r "${D}"/usr/python || die
}
