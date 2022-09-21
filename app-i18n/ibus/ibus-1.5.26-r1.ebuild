# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools bash-completion-r1 gnome2-utils python-r1 toolchain-funcs vala virtualx xdg-utils

GENTOO_VER=
DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="https://github.com/ibus/ibus/wiki"

[[ -n ${GENTOO_VER} ]] && \
	GENTOO_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P}-gentoo-patches-${GENTOO_VER}.tar.xz"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz
	${GENTOO_PATCHSET_URI}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="X appindicator +emoji gtk2 +gtk3 +gtk4 +gui +introspection nls +python systemd test +unicode vala wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	appindicator? ( gtk3 )
	python? (
		${PYTHON_REQUIRED_USE}
		introspection
	)
	test? ( gtk3 )
	vala? ( introspection )
	X? ( gtk3 )
"
DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.65.0:2
	gnome-base/dconf
	gnome-base/librsvg:2
	sys-apps/dbus[X?]
	X? (
		x11-libs/libX11
		>=x11-libs/libXfixes-6.0.0
	)
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	gtk4? ( gui-libs/gtk:4 )
	gui? (
		x11-libs/libX11
		x11-libs/libXi
	)
	introspection? ( dev-libs/gobject-introspection )
	nls? ( virtual/libintl )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)"
RDEPEND="${DEPEND}
	python? (
		gui? (
			x11-libs/gtk+:3[introspection]
		)
	)"
BDEPEND="
	$(vala_depend)
	dev-libs/glib:2
	dev-util/glib-utils
	virtual/pkgconfig
	x11-misc/xkeyboard-config
	emoji? (
		app-i18n/unicode-cldr
		app-i18n/unicode-emoji
	)
	nls? ( sys-devel/gettext )
	unicode? ( app-i18n/unicode-data )"

PATCHES=(
	"${FILESDIR}"/${P}-src-Fix-refcounting-issues.patch
)

src_prepare() {
	vala_src_prepare --ignore-use
	sed -i "/UCD_DIR=/s/\$with_emoji_annotation_dir/\$with_ucd_dir/" configure.ac
	if ! has_version 'x11-libs/gtk+:3[wayland]'; then
		touch ui/gtk3/panelbinding.vala \
			ui/gtk3/emojierapp.vala || die
	fi
	if ! use emoji; then
		touch \
			tools/main.vala \
			ui/gtk3/panel.vala || die
	fi
	if ! use appindicator; then
		touch ui/gtk3/panel.vala || die
	fi
	if [[ -n ${GENTOO_VER} ]]; then
		einfo "Try to apply Gentoo specific patch set"
		eapply "${WORKDIR}"/patches-gentoo/*.patch
	fi

	# for multiple Python implementations
	sed -i "s/^\(PYGOBJECT_DIR =\).*/\1/" bindings/Makefile.am || die
	# fix for parallel install
	sed -i "/^if ENABLE_PYTHON2/,/^endif/d" bindings/pygobject/Makefile.am || die
	# require user interaction
	sed -i "/^TESTS += ibus-\(compose\|keypress\)/d" src/tests/Makefile.am || die

	sed -i "/^bash_completion/d" tools/Makefile.am || die

	default
	eautoreconf
	xdg_environment_reset
}

src_configure() {
	local unicodedir="${EPREFIX}"/usr/share/unicode
	local python_conf=()
	if use python; then
		python_setup
		python_conf+=(
			$(use_enable gui setup)
			--with-python=${EPYTHON}
		)
	else
		python_conf+=( --disable-setup )
	fi

	if tc-is-cross-compiler && { use emoji || use unicode; }; then
		mkdir -p "${S}-build"
		pushd "${S}-build" >/dev/null 2>&1 || die
		ECONF_SOURCE=${S} econf_build --enable-static \
			--disable-{dconf,gtk{2,3},python-library,shared,xim} \
			ISOCODES_{CFLAG,LIB}S=-DSKIP \
			$(use_enable emoji emoji-dict) \
			$(use_enable unicode unicode-dict) \
			$(use_with unicode ucd-dir "${EPREFIX}/usr/share/unicode-data")
		popd >/dev/null 2>&1 || die
	fi

	local myconf=(
		$(use_enable X xim)
		$(use_enable appindicator)
		$(use_enable emoji emoji-dict)
		$(use_with emoji unicode-emoji-dir "${unicodedir}"/emoji)
		$(use_with emoji emoji-annotation-dir "${unicodedir}"/cldr/common/annotations)
		$(use_enable gtk2)
		$(use_enable gtk3)
		$(use_enable gtk4)
		$(use_enable gui ui)
		$(use_enable introspection)
		$(use_enable nls)
		$(use_enable systemd systemd-services)
		$(use_enable test tests)
		$(use_enable unicode unicode-dict)
		$(use_with unicode ucd-dir "${EPREFIX}/usr/share/unicode-data")
		$(use_enable vala)
		$(use_enable wayland)
		"${python_conf[@]}"
	)
	econf "${myconf[@]}"
}

src_compile() {
	if tc-is-cross-compiler && { use emoji || use unicode; }; then
		emake -C "${S}-build/src" \
			$(usex emoji emoji-parser '') \
			$(usex unicode unicode-parser '')
		emake -C src \
			$(usex emoji emoji-parser '') \
			$(usex unicode unicode-parser '')
		cp \
			$(usex emoji "${S}-build/src/emoji-parser" '') \
			$(usex unicode "${S}-build/src/unicode-parser" '') \
			src || die
	fi
	emake
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	virtx emake -j1 check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	if use python; then
		python_install() {
			emake -C bindings/pygobject \
				pyoverridesdir="$(${EPYTHON} -c 'import gi; print(gi._overridesdir)')" \
				DESTDIR="${D}" \
				install

			python_optimize
		}
		python_foreach_impl python_install
	fi

	keepdir /usr/share/ibus/engine

	newbashcomp tools/${PN}.bash ${PN}

	insinto /etc/X11/xinit/xinput.d
	newins xinput-${PN} ${PN}.conf

	# Undo compression of man page
	find "${ED}"/usr/share/man -type f -name '*.gz' -exec gzip -d {} \; || die
}

pkg_postinst() {
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	xdg_icon_cache_update
	gnome2_schemas_update
	dconf update
}

pkg_postrm() {
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	xdg_icon_cache_update
	gnome2_schemas_update
}
