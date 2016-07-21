# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Searchtimer and replacement of the VDR program menu"
HOMEPAGE="http://winni.vdr-developer.org/epgsearch"

case ${P#*_} in
	rc*|beta*)
		MY_P="${P/_/.}"
		SRC_URI="http://winni.vdr-developer.org/epgsearch/downloads/beta/${MY_P}.tgz"
		S="${WORKDIR}/${MY_P#vdr-}"
		;;
	*)
		SRC_URI="http://winni.vdr-developer.org/epgsearch/downloads/${P}.tgz"
		;;
esac

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pcre tre linguas_de"

DEPEND=">=media-video/vdr-1.3.45
	pcre? ( dev-libs/libpcre )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"

REQUIRED_USE="pcre? ( !tre )
	tre? ( !pcre )"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include conflictcheck.c

	if has_version ">=media-video/vdr-1.7.25"; then
		epatch "${FILESDIR}/${P}_vdr-1.7.25.diff"
	fi

	if has_version ">=media-video/vdr-1.7.28"; then
		sed -i "s:SetRecording(recording->FileName(), recording->Title:SetRecording(recording->FileName:" menu_searchresults.c
	fi

	if has_version ">=media-video/vdr-1.7.33"; then
		epatch "${FILESDIR}/${P}_vdr-1.7.33.diff"
	fi

	epatch "${FILESDIR}/${P}_vdr-2.1.2.diff"

	# disable automagic deps
	sed -i Makefile -e '/^AUTOCONFIG=/s/^/#/'

	if use pcre; then
		einfo "Using pcre for regexp searches"
		sed -i Makefile -e 's:^#REGEXLIB = pcre:REGEXLIB = pcre:'
	fi

	if use tre; then
		einfo "Using tre for unlimited fuzzy searches"
		sed -i Makefile -e 's:^#REGEXLIB = pcre:REGEXLIB = tre:'
	fi

	# install conf-file disabled
	sed -e '/^Menu/s:^:#:' -i conf/epgsearchmenu.conf

	# Get a rid of the broken symlinks
	rm -f README{,.DE} MANUAL
}

src_install() {
	vdr-plugin-2_src_install

	diropts "-m755 -o vdr -g vdr"
	keepdir /etc/vdr/plugins/epgsearch
	insinto /etc/vdr/plugins/epgsearch

	doins conf/epgsearchmenu.conf
	doins conf/epgsearchconflmail.templ conf/epgsearchupdmail.templ

	dodoc conf/*.templ

	doman man/en/*.gz

	if use linguas_de; then
		doman -i18n=de man/de/*.gz
	fi
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-0.9.18"
	previous_less_than_0_9_18=$?
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst
	if [[ $previous_less_than_0_9_18 = 0 ]] ; then
		elog "Moving config-files to new location /etc/vdr/plugins/epgsearch"
		cd "${ROOT}"/etc/vdr/plugins
		local f
		local moved=""
		for f in epgsearch*.* .epgsearch*; do
			[[ -e ${f} ]] || continue
			mv "${f}" "${ROOT}/etc/vdr/plugins/epgsearch"
			moved="${moved} ${f}"
		done
		elog "These files were moved:${moved}"
	fi
}
