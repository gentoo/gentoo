# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: create timers from epg content based on saved search expressions"
HOMEPAGE="http://winni.vdr-developer.org/epgsearch/index_eng.html"
GIT_COMMIT_ID="d8cff1a251ef2b54f1de3f8e6ea55a838eeb73c3"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-epgsearch.git/snapshot/vdr-plugin-epgsearch-${GIT_COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="conflictcheckonly epgsearchonly pcre quicksearch tre"
REQUIRED_USE="?? ( pcre tre )"

DEPEND="
	>=media-video/vdr-2.4
	pcre? ( dev-libs/libpcre )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/groff
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.0_makefile.patch"
	"${FILESDIR}/${PN}-2.4.0_docsrc2man-no-gzip.patch"
	"${FILESDIR}/${P}_clang.patch"
)

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*
	usr/bin/createcats"
S="${WORKDIR}/vdr-plugin-epgsearch-${GIT_COMMIT_ID}"

src_prepare() {
	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po \
		|| die "cannot remove untranslated .po files"

	if use conflictcheckonly; then
		sed -e "s:install-\$(PLUGIN3)::" -i Makefile || die "cannot modify Makefile"
	fi

	if use epgsearchonly; then
		sed -e "s:install-\$(PLUGIN2)::" -i Makefile || die "cannot modify Makefile"
	fi

	if use quicksearch; then
		sed -e "s:install-\$(PLUGIN4)::" -i Makefile || die "cannot modify Makefile"
	fi

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
	local DOCS=( conf/*.templ HISTORY* README.Translators )
	vdr-plugin-2_src_install

	diropts -m 755 -o vdr -g vdr
	insopts -m 644 -o vdr -g vdr
	keepdir /etc/vdr/plugins/epgsearch
	insinto /etc/vdr/plugins/epgsearch
	doins conf/*

	doman man/en/*
	doman -i18n=de man/de/*
}
