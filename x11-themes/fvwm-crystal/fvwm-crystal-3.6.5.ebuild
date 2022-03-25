# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit readme.gentoo-r1 python-single-r1

DESCRIPTION="Configurable FVWM theme with transparency and freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

case ${PV} in
*9999)
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/fvwm-crystal/code"
	SRC_URI=""
	S="${WORKDIR}/${PN}"
	src_unpack() {
		subversion_src_unpack
	};;
esac

RDEPEND="${PYTHON_DEPS}
	acct-group/fvwm-crystal
	>=x11-wm/fvwm-2.6.9[png]
	virtual/imagemagick-tools
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( x11-misc/hsetroot media-gfx/feh )
	sys-apps/sed
	sys-devel/bc
	virtual/awk
	x11-apps/xwd
	media-sound/alsa-utils"

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
	rm -vf "${ED}/usr/share/doc/${PF}"/LICENSE

	python_doscript "${ED}/usr/bin/${PN}".{apps,wallpaper}
	python_scriptinto "/usr/share/${PN}"/fvwm/scripts/FvwmMPD
	python_doscript "${ED}/usr/share/${PN}"/fvwm/scripts/FvwmMPD/*.py
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	elog "Many applications can extend functionality of fvwm-crystal."
	elog "They are listed in ${EROOT}/usr/share/doc/${PF}/INSTALL.bz2"
	elog "Popular supported softwares are:"
	elog "- x11-misc/xdg-user-dirs (the gtk USE is not needed) to"
	elog "  get localized XDG user directories support"
	elog "- sys-apps/systemd for hibernate/resume support"
	elog "- media-sound/jack-audio-connection-kit for a professional sound server"
	elog "- several media players"
}
