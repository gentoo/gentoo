# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1

DESCRIPTION="A tool to prepare for (comparatively) safe time64 transition"
HOMEPAGE="https://github.com/projg2/time64-prep/"
SRC_URI="
	https://github.com/projg2/time64-prep/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="-m68k ~x86"
# This can't work on m68k. We use the opportunity to switch to -maligned-int,
# and then the ABI changes too much...

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-util/patchelf
	$(python_gen_cond_dep '
		dev-python/pyelftools[${PYTHON_USEDEP}]
		sys-apps/portage[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${PYTHON_DEPS}
"

src_install() {
	python_doscript time64-prep
	einstalldocs
}
