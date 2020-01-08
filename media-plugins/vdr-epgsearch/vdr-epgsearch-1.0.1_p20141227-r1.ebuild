# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
KEYWORDS="amd64 x86"
IUSE="+conflictcheckonly +epgsearchonly l10n_de pcre +quicksearch tre"
REQUIRED_USE="?? ( pcre tre )"

DEPEND="media-video/vdr
	pcre? ( dev-libs/libpcre )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"
QA_FLAGS_IGNORED="usr/lib/vdr/plugins/libvdr-.* usr/lib64/vdr/plugins/libvdr-.* usr/bin/createcats"

src_prepare() {
	# make detection in vdr-plugin-2.eclass for new Makefile handling happy
	echo "# SOFILE" >> Makefile || die "cannot write to Makefile"

	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po || die "cannot remove .po files"

	local PATCHES=(
		"${FILESDIR}/vdr-epgsearch-1.x.makefile.patch"
		"${FILESDIR}/fix-manpage-generation.diff"
		)

	use conflictcheckonly || sed -e "s:install-\$(PLUGIN3)::" -i Makefile || die "cannot modify Makefile"
	use epgsearchonly || sed -e "s:install-\$(PLUGIN2)::" -i Makefile || die "cannot modify Makefile"
	use quicksearch || sed -e "s:install-\$(PLUGIN4)::" -i Makefile || die "cannot modify Makefile"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include conflictcheck.c

	# install conf-file disabled
	sed -e '/^Menu/s:^:#:' -i conf/epgsearchmenu.conf || die "cannot modify epgsearchmenu.conf"

	# Get rid of the broken symlink
	rm README || die "cannot remove broken symlink"
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
	DOCS=( conf/*.templ HISTORY* README.Translators )
	vdr-plugin-2_src_install

	diropts -m 755 -o vdr -g vdr
	insopts -m 644 -o vdr -g vdr
	keepdir /etc/vdr/plugins/epgsearch
	insinto /etc/vdr/plugins/epgsearch
	doins conf/*

	doman man/en/*

	if use l10n_de; then
		doman -i18n=de man/de/*
	fi
}
