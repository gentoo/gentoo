# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit readme.gentoo-r1 python-single-r1 optfeature

DESCRIPTION="Configurable FVWM theme with transparency and freedesktop compatible menu"
HOMEPAGE="https://fvwm-crystal.sourceforge.net/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fvwm-crystal/fvwm-crystal.git"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	acct-group/fvwm-crystal
	app-alternatives/awk
	media-sound/alsa-utils
	sys-apps/sed
	sys-devel/bc
	virtual/imagemagick-tools
	x11-apps/xwd
	|| ( x11-misc/hsetroot media-gfx/feh )
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( >=x11-wm/fvwm3-1.0.4[go] >=x11-wm/fvwm-2.6.9[png] )
"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="After a first time installation, execute the following commands:
	$ cp -r "${EROOT}"/usr/share/doc/"${PF}"/addons/Xresources ~/.Xresources
	$ cp -r "${EROOT}"/usr/share/doc/"${PF}"/addons/Xsession ~/.xinitrc
You can edit these files at your convenience.

Many applications can extend functionality of fvwm-crystal.
They are listed in "${EROOT}"/usr/share/doc/"${PF}"/INSTALL.*

To be able to use the exit menu, each user using ${PN}
must be in the group fvwm-crystal.
You can do that as root with:
	$ useradd -G fvwm-crystal <user_name>
and log out and in again.
"

src_install() {
	emake DESTDIR="${ED}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}" \
		prefix="${EPREFIX}/usr" \
		install
	# GNU License is globally in the portage tree
	rm -vf "${ED}/usr/share/doc/${PF}"/LICENSE || die

	python_doscript "${ED}/usr/bin/${PN}".{apps,wallpaper}
	python_scriptinto "/usr/share/${PN}"/fvwm/scripts/FvwmMPD
	python_doscript "${ED}/usr/share/${PN}"/fvwm/scripts/FvwmMPD/*.py
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	optfeature "localized XDG user directories support" "x11-misc/xdg-user-dirs"
	optfeature "hibernate/resume support" "sys-apps/systemd"
	optfeature "professional sound server" "virtual/jack"
}
