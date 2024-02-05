# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Additional third-party dictionaries for Mozc"

HOMEPAGE="http://linuxplayers.g1.xrea.com/mozc-ut.html"

MERGE_UT_DICTIONARIES_GIT_REVISION="a3d6fc4005aff2092657ebca98b9de226e1c617f"
MOZCDIC_UT_ALT_CANNADIC_GIT_REVISION="4e548e6356b874c76e8db438bf4d8a0b452f2435"
MOZCDIC_UT_EDICT2_GIT_REVISION="b2eec665b81214082d61acee1c5a1b5b115baf1a"
MOZCDIC_UT_JAWIKI_GIT_REVISION="6e08b8c823f3d2d09064ad2080e7a16552a7b473"
MOZCDIC_UT_NEOLOGD_GIT_REVISION="bf9d0d217107f2fb2e7d1a26648ef429d9fdcd27"
MOZCDIC_UT_PERSONAL_NAMES_GIT_REVISION="8a500f82c553936cbdd33b85955120e731069d44"
MOZCDIC_UT_PLACE_NAMES_GIT_REVISION="3db0d6cb2c748bd9b3551a174ce8c4f0a50f2742"
MOZCDIC_UT_SKK_JISYO_GIT_REVISION="ee94f6546ce52edfeec0fd203030f52d4d99656f"
MOZCDIC_UT_SUDACHIDICT_GIT_REVISION="55f61c3fca81dec661c36c73eb29b2631c8ed618"

DICT_SRC_BASE="https://github.com/utuhiro78"
SRC_URI="
	https://github.com/utuhiro78/merge-ut-dictionaries/archive/${MERGE_UT_DICTIONARIES_GIT_REVISION}.tar.gz -> merge-ut-dictionaries-${MERGE_UT_DICTIONARIES_GIT_REVISION}.tar.gz
	https://raw.githubusercontent.com/google/mozc/master/src/data/dictionary_oss/id.def
	https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-all-titles-in-ns0.gz
	alt-cannadic? ( ${DICT_SRC_BASE}/mozcdic-ut-alt-cannadic/archive/${MOZCDIC_UT_ALT_CANNADIC_GIT_REVISION}.tar.gz -> mozcdic-ut-alt-cannadic-${MOZCDIC_UT_ALT_CANNADIC_GIT_REVISION}.tar.gz )
	edict? ( ${DICT_SRC_BASE}/mozcdic-ut-edict2/archive/${MOZCDIC_UT_EDICT2_GIT_REVISION}.tar.gz -> mozcdic-ut-edict2-${MOZCDIC_UT_EDICT2_GIT_REVISION}.tar.gz )
	jawiki? ( ${DICT_SRC_BASE}/mozcdic-ut-jawiki/archive/${MOZCDIC_UT_JAWIKI_GIT_REVISION}.tar.gz -> mozcdic-ut-jawiki-${MOZCDIC_UT_JAWIKI_GIT_REVISION}.tar.gz )
	neologd? ( ${DICT_SRC_BASE}/mozcdic-ut-neologd/archive/${MOZCDIC_UT_NEOLOGD_GIT_REVISION}.tar.gz -> mozcdic-ut-neologd-${MOZCDIC_UT_NEOLOGD_GIT_REVISION}.tar.gz )
	personal-names? ( ${DICT_SRC_BASE}/mozcdic-ut-personal-names/archive/${MOZCDIC_UT_PERSONAL_NAMES_GIT_REVISION}.tar.gz -> mozcdic-ut-personal-names-${MOZCDIC_UT_PERSONAL_NAMES_GIT_REVISION}.tar.gz )
	place-names? ( ${DICT_SRC_BASE}/mozcdic-ut-place-names/archive/${MOZCDIC_UT_PLACE_NAMES_GIT_REVISION}.tar.gz -> mozcdic-ut-place-names-${MOZCDIC_UT_PLACE_NAMES_GIT_REVISION}.tar.gz )
	skk-jisyo? ( ${DICT_SRC_BASE}/mozcdic-ut-skk-jisyo/archive/${MOZCDIC_UT_SKK_JISYO_GIT_REVISION}.tar.gz -> mozcdic-ut-skk-jisyo-${MOZCDIC_UT_SKK_JISYO_GIT_REVISION}.tar.gz )
	sudachidict? ( ${DICT_SRC_BASE}/mozcdic-ut-sudachidict/archive/${MOZCDIC_UT_SUDACHIDICT_GIT_REVISION}.tar.gz -> mozcdic-ut-sudachidict-${MOZCDIC_UT_SUDACHIDICT_GIT_REVISION}.tar.gz )
	"

S="${WORKDIR}/merge-ut-dictionaries-${MERGE_UT_DICTIONARIES_GIT_REVISION}/src"

# merge-ut-dictionaries: Apache-2.0
# id.def: BSD
# jawiki-latest-all-titles-in-ns0.gz: CC-BY-SA-3.0
# alt-cannadic: GPL-2
# edict2: CC-BY-SA-4.0
# jawiki: CC-BY-SA-3.0
# neologd: Complex but seems to be public-domain
# personal-names: Apache-2.0
# place-names: public-domain
# skk-jisyo: GPL-2+
# sudachidict: Apache-2.0
LICENSE="
	Apache-2.0
	BSD
	CC-BY-SA-3.0
	alt-cannadic? ( GPL-2 )
	edict? ( CC-BY-SA-4.0 )
	neologd? ( public-domain )
	place-names? ( public-domain )
	skk-jisyo? ( GPL-2+ )
	"

SLOT="0"

KEYWORDS="~amd64"

IUSE="alt-cannadic edict +jawiki +neologd +personal-names +place-names skk-jisyo sudachidict"
REQUIRED_USE="|| ( alt-cannadic edict jawiki neologd personal-names place-names skk-jisyo sudachidict )"

BDEPEND="dev-lang/ruby"

PATCHES=(
	"${FILESDIR}"/${P}-no-remote-access.patch
)

src_unpack() {
	unpack merge-ut-dictionaries-${MERGE_UT_DICTIONARIES_GIT_REVISION}.tar.gz

	cp "${DISTDIR}/id.def" "${S}" || die
	cp "${DISTDIR}/jawiki-latest-all-titles-in-ns0.gz" "${S}" || die

	if use alt-cannadic; then
		unpack mozcdic-ut-alt-cannadic-${MOZCDIC_UT_ALT_CANNADIC_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-alt-cannadic-${MOZCDIC_UT_ALT_CANNADIC_GIT_REVISION} "${S}/mozcdic-ut-alt-cannadic" || die
	fi

	if use edict; then
		unpack mozcdic-ut-edict2-${MOZCDIC_UT_EDICT2_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-edict2-${MOZCDIC_UT_EDICT2_GIT_REVISION} "${S}/mozcdic-ut-edict2" || die
	fi

	if use jawiki; then
		unpack mozcdic-ut-jawiki-${MOZCDIC_UT_JAWIKI_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-jawiki-${MOZCDIC_UT_JAWIKI_GIT_REVISION} "${S}/mozcdic-ut-jawiki" || die
	fi

	if use neologd; then
		unpack mozcdic-ut-neologd-${MOZCDIC_UT_NEOLOGD_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-neologd-${MOZCDIC_UT_NEOLOGD_GIT_REVISION} "${S}/mozcdic-ut-neologd" || die
	fi
	
	if use personal-names; then
		unpack mozcdic-ut-personal-names-${MOZCDIC_UT_PERSONAL_NAMES_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-personal-names-${MOZCDIC_UT_PERSONAL_NAMES_GIT_REVISION} "${S}/mozcdic-ut-personal-names" || die
	fi

	if use place-names; then
		unpack mozcdic-ut-place-names-${MOZCDIC_UT_PLACE_NAMES_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-place-names-${MOZCDIC_UT_PLACE_NAMES_GIT_REVISION} "${S}/mozcdic-ut-place-names" || die
	fi

	if use skk-jisyo; then
		unpack mozcdic-ut-skk-jisyo-${MOZCDIC_UT_SKK_JISYO_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-skk-jisyo-${MOZCDIC_UT_SKK_JISYO_GIT_REVISION} "${S}/mozcdic-ut-skk-jisyo" || die
	fi

	if use sudachidict; then
		unpack mozcdic-ut-sudachidict-${MOZCDIC_UT_SUDACHIDICT_GIT_REVISION}.tar.gz
		cp -r mozcdic-ut-sudachidict-${MOZCDIC_UT_SUDACHIDICT_GIT_REVISION} "${S}/mozcdic-ut-sudachidict" || die
	fi
}

src_compile() {
	sh make.sh || die
}

src_install() {
	insinto /usr/share/${PN}
	doins mozcdic-ut.txt
}
