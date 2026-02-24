# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="tk"

inherit meson python-single-r1 xdg

DESCRIPTION="Multi-featured system monitor GUI written in Python"
HOMEPAGE="https://github.com/hakandundar34coding/system-monitoring-center/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hakandundar34coding/${PN}"
else
	SRC_URI="https://github.com/hakandundar34coding/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/dmidecode
	sys-apps/hwdata
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP},tk]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	sed -i "s|@PYTHON@|${PYTHON}|" "${S}/src/${PN}.in" || die

	default
}

src_install() {
	meson_src_install
	python_optimize "${ED}/usr/share/${PN}"

	mv "${ED}/usr/share/appdata" "${ED}/usr/share/metainfo" || die
}
