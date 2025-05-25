# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: USE=java isn't really doing anything here right now. It also
# uses jre:11 which may be unnecessary.
inherit java-pkg-opt-2 prefix unpacker xdg

BASE_SRC_URI="https://download.documentfoundation.org/libreoffice/stable/${PV}/deb"

DESCRIPTION="A full office productivity suite. Binary package"
HOMEPAGE="https://www.libreoffice.org"
SRC_URI_AMD64="
	${BASE_SRC_URI}/x86_64/LibreOffice_${PV}_Linux_x86-64_deb.tar.gz
"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
"
S="${WORKDIR}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="java offlinehelp python"

# "en:en-US" for mapping from Gentoo "en" to upstream "en-US" etc.
LANGUAGES_HELP=(
	am ar ast bg bn-IN bn bo bs ca-valencia ca cs da de dz el en-GB en:en-US en-ZA
	eo es et eu fi fr gl gu he hi hr hu id is it ja ka km ko lo lt lv mk nb ne nl
	nn om pl pt-BR pt ro ru si sid sk sl sq sv ta tg tr ug uk vi zh-CN zh-TW
)
LANGUAGES=(
	${LANGUAGES_HELP[@]} af as be br brx ckb cy dgo dsb fa fur fy ga gd gug hsb kab
	kk kmr-Latn kn kok ks lb mai ml mn mni mr my nr nso oc or pa:pa-IN rw sa:sa-IN
	sat sd sr-Latn sr ss st sw-TZ szl te th tn ts tt uz ve vec xh zu
)

handle_lang() {
	local lang helppack langpack

	for lang in ${LANGUAGES_HELP[@]}; do
		SRC_URI+=" l10n_${lang%:*}? (
			offlinehelp? (
				${BASE_SRC_URI}/x86_64/LibreOffice_${PV}_Linux_x86-64_deb_helppack_${lang#*:}.tar.gz
			)
		)"
	done
	for lang in ${LANGUAGES[@]}; do
		if [[ ${lang%:*} != en ]]; then
			SRC_URI+=" l10n_${lang%:*}? (
				${BASE_SRC_URI}/x86_64/LibreOffice_${PV}_Linux_x86-64_deb_langpack_${lang#*:}.tar.gz
			)"
		fi
		IUSE+=" l10n_${lang%:*}"
	done
}
handle_lang

RDEPEND="
	acct-group/libreoffice
	acct-user/libreoffice
	app-accessibility/at-spi2-core:2
	app-arch/unzip
	app-arch/zip
	app-crypt/mit-krb5
	dev-libs/glib:2
	dev-libs/gobject-introspection
	|| (
		<dev-libs/libxml2-2.14
		dev-libs/libxml2-compat:2
	)
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	gnome-base/dconf
	media-fonts/liberation-fonts
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/mesa[egl(+)]
	net-dns/avahi
	net-print/cups
	sys-apps/dbus
	sys-devel/gcc:*
	sys-fs/e2fsprogs
	sys-libs/glibc
	sys-libs/zlib
	virtual/libcrypt
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	|| ( x11-misc/xdg-utils kde-plasma/kde-cli-tools )
	java? ( virtual/jre:11 )
"
RESTRICT="test strip"

QA_PREBUILT="opt/* usr/*"

src_unpack() {
	default

	BINPKG_BASE=$(find "${WORKDIR}" -mindepth 1 -maxdepth 1 -name 'LibreOffice_*_deb' -type d -print || die)
	BINPKG_BASE="${BINPKG_BASE##${WORKDIR}}"
	[[ -z ${BINPKG_BASE} ]] && die "Failed to detect binary package directory!"

	# We don't package Firebird anymore
	rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-firebird*_amd64.deb || die

	# The GNOME and KDE integration .debs are a mix of both:
	# 1) VCLs (GUI backends), and
	# 2) Actual DE integration (which needs KF5 and so on)
	#
	# For now, we always install the GTK one, and don't install the Qt
	# one (as it's Qt5-based).
	#
	# KDE integration itself also requires KF5 as of 25.2.0, so we choose not to use it.
	# Can revisit when it's KF6-based.
	rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-kde-integration*_amd64.deb || die

	# Bundled Python is used (3.10 as of 25.2.0), so no need for system dependency.
	if ! use python ; then
		rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-python-script-provider*_amd64.deb || die
	fi

	# The downloaded .deb has a DEBS/ directory with e.g. libreoffice25.2_25.2.0.3-3_amd64.deb
	# and many other .debs for each component.
	readarray -t -d '' debs < <(find "${WORKDIR}" -name '*.deb' -type f -print0 || die)

	local deb
	for deb in "${debs[@]}" ; do
		unpack_deb "${deb}"
	done
}

src_prepare() {
	default

	cat <<-EOF > "${T}"/50-${PN} || die
	SEARCH_DIRS_MASK="@GENTOO_PORTAGE_EPREFIX@/opt/libreoffice${PV%*.*}"
	EOF
	eprefixify "${T}"/50-${PN}
}

src_install() {
	dodir /usr /opt
	mv "${S}"/usr/local/* "${S}"/usr || die
	cp -aR "${S}"/opt/* "${ED}"/opt/ || die
	cp -aR "${S}"/usr/* "${ED}"/usr/ || die
	rmdir "${ED}"/usr/local || die

	# Convenience link
	# bug #954332
	dosym libreoffice${PV%*.*} /usr/bin/${PN}

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild
	doins "${T}/50-${PN}"
}
