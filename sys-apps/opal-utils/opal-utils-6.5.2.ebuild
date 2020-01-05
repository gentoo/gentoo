# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit linux-info python-any-r1 systemd toolchain-funcs

DESCRIPTION="OPAL firmware utilities"
HOMEPAGE="https://github.com/open-power/skiboot"
SRC_URI="https://github.com/open-power/skiboot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~ppc64"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="doc? (
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
	')
)"

CONFIG_CHECK="~MTD_POWERNV_FLASH ~OPAL_PRD ~PPC_DT_CPU_FTRS ~SCOM_DEBUGFS"
ERROR_MTD_POWERND_FLASH="CONFIG_MTD_POWERND_FLASH is required to use pflash and opal-gard"
ERROR_OPAL_PRD="CONFIG_OPAL_PRD is required to run opal-prd daemon"
ERROR_SCOM_DEBUGFS="CONFIG_SCOM_DEBUGFS is required to use xscom-utils"

S="${WORKDIR}/skiboot-${PV}"

python_check_deps() {
	has_version "dev-python/recommonmark[${PYTHON_USEDEP}]" &&
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	linux-info_pkg_setup
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i '/^CFLAGS +=/ s/-g2 -ggdb//' external/opal-prd/Makefile || die
}

src_configure() {
	tc-export CC LD
	export OPAL_PRD_VERSION="${PV}"
	export GARD_VERSION="${PV}"
	export PFLASH_VERSION="${PV}"
	export XSCOM_VERSION="${PV}"
}

src_compile() {
	emake V=1 -C external/opal-prd
	emake V=1 -C external/gard
	emake V=1 -C external/pflash
	emake V=1 -C external/xscom-utils

	use doc && emake V=1 -C doc html
}

src_install() {
	emake -C external/opal-prd DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/gard DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/pflash DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	emake -C external/xscom-utils DESTDIR="${D}" prefix="${EPREFIX}/usr" install

	newinitd "${FILESDIR}"/opal-prd.initd opal-prd
	newconfd "${FILESDIR}"/opal-prd.confd opal-prd

	systemd_dounit external/opal-prd/opal-prd.service

	if use doc; then
		rm -r doc/_build/html/_sources || die
		local HTML_DOCS=( doc/_build/html/. )
	fi
	einstalldocs
}
