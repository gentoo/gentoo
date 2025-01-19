# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature xdg

DESCRIPTION="Graphical client for the Soulseek peer to peer network written in Python"
HOMEPAGE="https://nicotine-plus.org/"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nicotine-plus-${PV}"

LICENSE="GPL-3+ MIT CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

LANGS=( ca de es_CL es_ES et fr hu it lv nl pl pt_BR pt_PT ru tr uk zh_CN )
for l in ${LANGS[@]}; do
	IUSE+=" l10n_${l/_/-}"
done

# NOTE: good link - https://github.com/nicotine-plus/nicotine-plus/blob/master/doc/DEPENDENCIES.md
BDEPEND="
	sys-devel/gettext
	test? (
		|| (
		   >=gui-libs/gtk-4.6.9[broadway]
		   >=x11-libs/gtk+-3.22.30:3[broadway]
		)
	)
"
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	|| (
		>=gui-libs/gtk-4.6.9[introspection]
		>=x11-libs/gtk+-3.22.30:3[introspection]
	)
"

distutils_enable_tests pytest

DOCS=( {AUTHORS,NEWS,README}.md )

src_prepare() {
	default
	for l in ${LANGS[@]}; do
		if ! use l10n_${l/_/-}; then
			rm -v "${S}/po/${l}.po" || die "Failed to remove localization ${l}"
			sed -i -e "/${l}/d" "${S}/po/LINGUAS" || die
		fi
	done

	# remove update check test violating network sandbox
	# NOTE: not needed in >3.3.7 due to
	# https://github.com/nicotine-plus/nicotine-plus/commit/77e5dc6d603bc8e1bac7159ff3727e34072d34a8
	sed -i -e 's:test_update_check:_&:' \
		"${S}"/pynicotine/tests/unit/test_version.py || die
}

python_install() {
	distutils-r1_python_install
	use doc && dodoc -r doc/*
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Nicotine can work with both gtk3+ and gtk4."
	elog "The newer version is preferred but it has worse screen reader support"
	elog "If you need it you can switch to gtk3+ by running nicotine"
	elog "with an environmental variable like this:"
	elog "   $ NICOTINE_GTK_VERSION=3 nicotine"

	optfeature "Adwaita theme on GNOME (GTK 4)" gui-libs/libadwaita
	optfeature "Chat spellchecking (GTK 3)" app-text/gspell
}
