# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-single-r1 verify-sig

DESCRIPTION="Collection of QA scripts for ebuild development"
HOMEPAGE="https://codeberg.org/eli-schwartz/eschwartz-dev-scripts"
SRC_URI="
	https://codeberg.org/eli-schwartz/eschwartz-dev-scripts/releases/download/${PV}/${P}.tar.xz
	verify-sig? ( https://codeberg.org/eli-schwartz/eschwartz-dev-scripts/releases/download/${PV}/${P}.tar.xz.asc )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/portage
	$(python_gen_cond_dep '
		sys-apps/pkgcore[${PYTHON_USEDEP}]
	')

"
BDEPEND="
	${PYTHON_DEPS}
	verify-sig? ( sec-keys/openpgp-keys-eschwartz )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eschwartz.gpg

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/libexec
}
