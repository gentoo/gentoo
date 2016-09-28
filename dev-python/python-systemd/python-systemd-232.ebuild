# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python module for native access to the systemd facilities"
HOMEPAGE="https://github.com/systemd/python-systemd"
SRC_URI="https://github.com/systemd/python-systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

COMMON_DEPEND="
	sys-apps/systemd:0=
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd[python(-)]
"

PATCHES=(
	"${FILESDIR}"/232-0001-tests-skip-fdstore-tests-if-not-implemented.patch
	"${FILESDIR}"/232-0002-docs-fix-sphinx-format-warning.patch
	"${FILESDIR}"/232-0003-build-sys-add-doc-sync-target.patch
	"${FILESDIR}"/232-0004-tests-add-workaround-for-pre-232-system-returning-EI.patch
	"${FILESDIR}"/232-0005-_reader-use-proper-ifdef-guard-for-sd_j_open_files_f.patch
	"${FILESDIR}"/232-0006-build-sys-import-pytest-instead-of-py.test.patch
)

python_test() {
	pushd "${BUILD_DIR}/lib" > /dev/null || die
	"${PYTHON}" -m pytest -v . || die
	popd > /dev/null || die
}
