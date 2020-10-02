# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_8 )

inherit python-single-r1 autotools gnome2

DESCRIPTION="A password manager for GNOME"
HOMEPAGE="https://revelation.olasagasti.info/ https://github.com/mikelolasagasti/revelation"
SRC_URI="https://github.com/mikelolasagasti/revelation/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"


REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pycryptodomex[${PYTHON_USEDEP}]
                dev-python/pygobject[${PYTHON_USEDEP}]
                dev-libs/libpwquality[python,${PYTHON_USEDEP}]
	')
        x11-libs/gtk+:3
"

DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--disable-desktop-update \
		--disable-mime-update
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${ED}"
}
