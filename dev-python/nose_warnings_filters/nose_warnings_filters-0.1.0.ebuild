# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit python-r1

DESCRIPTION="A python module to inject warning filters during nosetest"
HOMEPAGE="https://github.com/Carreau/nose_warnings_filters"
SRC_URI="https://github.com/Carreau/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	dev-python/nose[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_test() {
	# nose_warnings_filters doesn't have a proper
	# testing suite, hence we run the only testing
	# script available
	export PYTHONPATH="${S}:${S}/${PN}/tests"
	touch "${S}/${PN}/tests/__init__.py" || die
	run_test() {
		"${PYTHON}" "${PN}"/tests/test_config.py \
			|| die "Failed running test script"
	}
	python_foreach_impl run_test
	unset PYTHONPATH
}

src_install() {
	python_moduleinto "${PN}"
	install_files() {
		python_domodule "${PN}/__init__.py"

		# Unfortunately, nose_warnings_filters is designed
		# as a wheel package, for which a METADATA file is
		# strictly required, otherwise a Runtime error is thrown
		local egg_dir="${D%/}$(python_get_sitedir)/${PN}-${PV}.dist-info"
		mkdir -p "${egg_dir}" || die
		cp entry_points.txt "${egg_dir}" || die
		touch "${egg_dir}"/METADATA || die
	}
	python_foreach_impl install_files
}
