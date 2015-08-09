# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: create timers from epg content based on saved search expressions"
HOMEPAGE="http://winni.vdr-developer.org/epgsearch"

case ${P#*_} in
	rc*|beta*)
		MY_P="${P/_/.}"
		SRC_URI="http://winni.vdr-developer.org/epgsearch/downloads/beta/${MY_P}.tgz"
		S="${WORKDIR}/${MY_P#vdr-}"
		;;
	p*)
		GIT_COMMIT_ID="a908daa4c5c6edd6c560ed96939358b4352e9b42"
		GIT_COMMIT_DATE="20141227"
		SRC_URI="http://projects.vdr-developer.org/git/vdr-plugin-epgsearch.git/snapshot/vdr-plugin-epgsearch-${GIT_COMMIT_ID}.tar.gz
		-> ${P}.tar.gz"
		S="${WORKDIR}/vdr-plugin-epgsearch-${GIT_COMMIT_ID}"
		;;
	*)
		SRC_URI="http://winni.vdr-developer.org/epgsearch/downloads/${P}.tgz"
		;;
esac

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+conflictcheckonly +epgsearchonly linguas_de pcre +quicksearch tre"

DEPEND="media-video/vdr
	pcre? ( dev-libs/libpcre )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"

REQUIRED_USE="pcre? ( !tre )
	tre? ( !pcre )"

src_prepare() {
	# make detection in vdr-plugin-2.eclass for new Makefile handling happy
	echo "# SOFILE" >> Makefile

	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	epatch "${FILESDIR}/vdr-epgsearch-1.0.1_beta5_makefile.diff"

	use conflictcheckonly || sed -e "s:install-\$(PLUGIN3)::" -i Makefile
	use epgsearchonly || sed -e "s:install-\$(PLUGIN2)::" -i Makefile
	use quicksearch || sed -e "s:install-\$(PLUGIN4)::" -i Makefile

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include conflictcheck.c

	# install conf-file disabled
	sed -e '/^Menu/s:^:#:' -i conf/epgsearchmenu.conf

	# Get rid of the broken symlinks
	rm -f README{,.DE} MANUAL
}

src_compile() {
	BUILD_PARAMS="SENDMAIL=/usr/bin/sendmail AUTOCONFIG=0"

	if use pcre; then
		BUILD_PARAMS+=" REGEXLIB=pcre"
		einfo "Using pcre for regexp searches"
	fi

	if use tre; then
		BUILD_PARAMS+=" REGEXLIB=tre"
		einfo "Using tre for unlimited fuzzy searches"
	fi

	vdr-plugin-2_src_compile
}

src_install() {
	vdr-plugin-2_src_install

	diropts "-m755 -o vdr -g vdr"
	keepdir /etc/vdr/plugins/epgsearch
	insinto /etc/vdr/plugins/epgsearch

	doins conf/epgsearchmenu.conf
	doins conf/epgsearchconflmail.templ conf/epgsearchupdmail.templ

	nonfatal dodoc conf/*.templ HISTORY*

	doman man/en/*.gz

	if use linguas_de; then
		doman -i18n=de man/de/*.gz
	fi
}
