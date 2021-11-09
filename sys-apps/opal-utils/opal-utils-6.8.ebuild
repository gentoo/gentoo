# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit linux-info python-single-r1 systemd toolchain-funcs

DESCRIPTION="OPAL firmware utilities"
HOMEPAGE="https://github.com/open-power/skiboot"
SRC_URI="https://github.com/open-power/skiboot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2+"
SLOT="0"
KEYWORDS="ppc64"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${DEPEND} ${PYTHON_DEPS}"

BDEPEND="doc? ( $(python_gen_cond_dep '
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/recommonmark[${PYTHON_USEDEP}]')
)"

CONFIG_CHECK="~MTD_POWERNV_FLASH ~OPAL_PRD ~PPC_DT_CPU_FTRS ~SCOM_DEBUGFS"
ERROR_MTD_POWERND_FLASH="CONFIG_MTD_POWERND_FLASH is required to use pflash and opal-gard"
ERROR_OPAL_PRD="CONFIG_OPAL_PRD is required to run opal-prd daemon"
ERROR_SCOM_DEBUGFS="CONFIG_SCOM_DEBUGFS is required to use xscom-utils"

S="${WORKDIR}/skiboot-${PV}"

PATCHES=(
	"${FILESDIR}/flags.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	tc-export CC LD
	export OPAL_PRD_VERSION="${PV}"
	export GARD_VERSION="${PV}"
	export PFLASH_VERSION="${PV}"
	export XSCOM_VERSION="${PV}"
	export FFSPART_VERSION="${PV}"
}

src_compile() {
	emake V=1 -C external/opal-prd
	emake V=1 -C external/gard
	emake V=1 -C external/pflash
	emake V=1 -C external/xscom-utils
	emake V=1 -C external/ffspart

	use doc && emake V=1 -C doc html
}

src_install() {
	emake -C external/opal-prd DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/gard DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/pflash DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/xscom-utils DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	dosbin external/ffspart/ffspart

	python_domodule external/pci-scripts/ppc.py
	python_doscript external/pci-scripts/phberr.py

	newinitd "${FILESDIR}"/opal-prd.initd opal-prd
	newconfd "${FILESDIR}"/opal-prd.confd opal-prd

	systemd_dounit external/opal-prd/opal-prd.service

	if use doc; then
		rm -r doc/_build/html/_sources || die
		local HTML_DOCS=( doc/_build/html/. )
	fi
	einstalldocs
}

src_test() {
	emake V=1 -C external/opal-prd test
	emake V=1 -C external/gard check
	# this test is fragile and fails because of filename path
	rm external/pflash/test/tests/01-info || die
	emake V=1 -C external/pflash check
	emake V=1 -C external/ffspart check
}
