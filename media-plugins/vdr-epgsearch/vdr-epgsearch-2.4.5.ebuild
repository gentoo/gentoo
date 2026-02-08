# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: create timers from epg content based on saved search expressions"
HOMEPAGE="http://winni.vdr-developer.org/epgsearch/index_eng.html https://github.com/vdr-projects/vdr-plugin-epgsearch"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-epgsearch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-epgsearch-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="conflictcheckonly epgsearchonly pcre quicksearch tre"
REQUIRED_USE="?? ( pcre tre )"

DEPEND="
	>=media-video/vdr-2.4:=
	pcre? ( dev-libs/libpcre )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"
BDEPEND="
	acct-user/vdr
	sys-apps/groff
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${P}_docsrc2man-no-gzip.patch"
	"${FILESDIR}/${P}-Makefile.patch"
)

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*
	usr/bin/createcats"

src_prepare() {
	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po \
		|| die "cannot remove untranslated .po files"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include conflictcheck.c

	# install conf-file disabled
	sed -e '/^Menu/s:^:#:' -i conf/epgsearchmenu.conf || die "cannot modify epgsearchmenu.conf"
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
	if ! use conflictcheckonly; then
		BUILD_PARAMS+=" WITHOUT_CONFLICTCHECKONLY=1"
	fi
	if ! use epgsearchonly; then
		BUILD_PARAMS+=" WITHOUT_EPGSEARCHONLY=1"
	fi
	if ! use quicksearch; then
		BUILD_PARAMS+=" WITHOUT_QUICKSEARCH=1"
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
