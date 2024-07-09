# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

ESSAY_PN="rime-essay"
ESSAY_COMMIT="e0519d0579722a0871efb68189272cba61a7350b"
ARRAY_PN="rime-array"
ARRAY_COMMIT="557dbe38381de174fe96e53e9bf8c863a275307c"
BOPOMOFO_PN="rime-bopomofo"
BOPOMOFO_COMMIT="c7618f4f5728e1634417e9d02ea50d82b71956ab"
CANGJIE_PN="rime-cangjie"
CANGJIE_COMMIT="0ac8452eeb4abbcd8dd1f9e7314012310743285f"
COMBO_PINYIN_PN="rime-combo-pinyin"
COMBO_PINYIN_COMMIT="20cc1be16f5886e1a6b2bcb1c70010b5e0d8d61f"
DOUBLE_PINYIN_PN="rime-double-pinyin"
DOUBLE_PINYIN_COMMIT="69bf85d4dfe8bac139c36abbd68d530b8b6622ea"
EMOJI_PN="rime-emoji"
EMOJI_COMMIT="be7d308e42c4c4485229de37ec0afb7bafbfafc0"
IPA_PN="rime-ipa"
IPA_COMMIT="22b71710e029bcb412e9197192a638ab11bc2abf"
LUNA_PINYIN_PN="rime-luna-pinyin"
LUNA_PINYIN_COMMIT="44e555d1090a56d62a41a58153088406bcf87abd"
MID_CHINESE_PN="rime-middle-chinese"
MID_CHINESE_COMMIT="582e144e525525ac2b6c2498097d7c7919e84174"
PINYIN_SIMP_PN="rime-pinyin-simp"
PINYIN_SIMP_COMMIT="52b9c75f085479799553f2499c4f4c611d618cdf"
PRELUDE_PN="rime-prelude"
PRELUDE_COMMIT="3803f09458072e03b9ed396692ce7e1d35c88c95"
QUICK_PN="rime-quick"
QUICK_COMMIT="3fe5911ba608cb2df1b6301b76ad1573bd482a76"
SCJ_PN="rime-scj"
SCJ_COMMIT="cab5a0858765eff0553dd685a2d61d5536e9149c"
SOUTZOE_PN="rime-soutzoe"
SOUTZOE_COMMIT="beeaeca72d8e17dfd1e9af58680439e9012987dc"
STENOTYPE_PN="rime-stenotype"
STENOTYPE_COMMIT="f3e9189d5ce33c55d3936cc58e39d0c88b3f0c88"
STROKE_PN="rime-stroke"
STROKE_COMMIT="65fdbbf2f9485cc907cb9a6d6b9210938a50f71e"
TERRA_PINYIN_PN="rime-terra-pinyin"
TERRA_PINYIN_COMMIT="9df66c7edc9474a945e9f4744419b156278d1580"
WUBI_PN="rime-wubi"
WUBI_COMMIT="152a0d3f3efe40cae216d1e3b338242446848d07"
WUGNIU_PN="rime-wugniu"
WUGNIU_COMMIT="abd1ee98efbf170258fcf43875c21a4259e00b61"

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="https://rime.im/ https://github.com/rime/plum"

SRC_URI="
	https://github.com/rime/${BOPOMOFO_PN}/archive/${BOPOMOFO_COMMIT}.tar.gz -> ${BOPOMOFO_PN}-${PV}.tar.gz
	https://github.com/rime/${CANGJIE_PN}/archive/${CANGJIE_COMMIT}.tar.gz -> ${CANGJIE_PN}-${PV}.tar.gz
	https://github.com/rime/${ESSAY_PN}/archive/${ESSAY_COMMIT}.tar.gz -> ${ESSAY_PN}-${PV}.tar.gz
	https://github.com/rime/${LUNA_PINYIN_PN}/archive/${LUNA_PINYIN_COMMIT}.tar.gz -> ${LUNA_PINYIN_PN}-${PV}.tar.gz
	https://github.com/rime/${PRELUDE_PN}/archive/${PRELUDE_COMMIT}.tar.gz -> ${PRELUDE_PN}-${PV}.tar.gz
	https://github.com/rime/${STROKE_PN}/archive/${STROKE_COMMIT}.tar.gz -> ${STROKE_PN}-${PV}.tar.gz
	https://github.com/rime/${TERRA_PINYIN_PN}/archive/${TERRA_PINYIN_COMMIT}.tar.gz -> ${TERRA_PINYIN_PN}-${PV}.tar.gz
	extra? (
		https://github.com/rime/${ARRAY_PN}/archive/${ARRAY_COMMIT}.tar.gz -> ${ARRAY_PN}-${PV}.tar.gz
		https://github.com/rime/${COMBO_PINYIN_PN}/archive/${COMBO_PINYIN_COMMIT}.tar.gz
			-> ${COMBO_PINYIN_PN}-${PV}.tar.gz
		https://github.com/rime/${DOUBLE_PINYIN_PN}/archive/${DOUBLE_PINYIN_COMMIT}.tar.gz
			-> ${DOUBLE_PINYIN_PN}-${PV}.tar.gz
		https://github.com/rime/${EMOJI_PN}/archive/${EMOJI_COMMIT}.tar.gz -> ${EMOJI_PN}-${PV}.tar.gz
		https://github.com/rime/${IPA_PN}/archive/${IPA_COMMIT}.tar.gz -> ${IPA_PN}-${PV}.tar.gz
		https://github.com/rime/${MID_CHINESE_PN}/archive/${MID_CHINESE_COMMIT}.tar.gz -> ${MID_CHINESE_PN}-${PV}.tar.gz
		https://github.com/rime/${PINYIN_SIMP_PN}/archive/${PINYIN_SIMP_COMMIT}.tar.gz -> ${PINYIN_SIMP_PN}-${PV}.tar.gz
		https://github.com/rime/${QUICK_PN}/archive/${QUICK_COMMIT}.tar.gz -> ${QUICK_PN}-${PV}.tar.gz
		https://github.com/rime/${SCJ_PN}/archive/${SCJ_COMMIT}.tar.gz -> ${SCJ_PN}-${PV}.tar.gz
		https://github.com/rime/${SOUTZOE_PN}/archive/${SOUTZOE_COMMIT}.tar.gz -> ${SOUTZOE_PN}-${PV}.tar.gz
		https://github.com/rime/${STENOTYPE_PN}/archive/${STENOTYPE_COMMIT}.tar.gz -> ${STENOTYPE_PN}-${PV}.tar.gz
		https://github.com/rime/${WUBI_PN}/archive/${WUBI_COMMIT}.tar.gz -> ${WUBI_PN}-${PV}.tar.gz
		https://github.com/rime/${WUGNIU_PN}/archive/${WUGNIU_COMMIT}.tar.gz -> ${WUGNIU_PN}-${PV}.tar.gz
	)
"

S="${WORKDIR}"

# LGPL-3 :
#	essay bopomofo cangjie emoji ipa
#	luna-pinyin prelude quick stroke terra-pinyin wubi
# GPL-3 :
#	array combo-pinyin double-pinyin middle-chinese
#	scj soutzoe stenotype wugniu
# Apache-2 :
#	rime-pinyin-simp
LICENSE="GPL-3 LGPL-3 extra? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"

IUSE="extra"

RDEPEND="${DEPEND}"

RIME_DATA_DIR="/usr/share/rime-data"

rime_install_docs() {
	for p in "$@"; do
		local d="$(dirname "$p")"
		local f="$(basename "$p")"
		newdoc "$p" "${d%-*}_$f"
	done
}

src_install() {
	insinto "$RIME_DATA_DIR"

	local rime_bopomofo="${BOPOMOFO_PN}-${BOPOMOFO_COMMIT}"
	doins "${rime_bopomofo}"/{zhuyin,bopomofo{,_express,_tw}.schema}.yaml
	rime_install_docs "${rime_bopomofo}"/{AUTHORS,LICENSE,README.md}

	local rime_cangjie="${CANGJIE_PN}-${CANGJIE_COMMIT}"
	doins "${rime_cangjie}"/cangjie5{.dict,.schema,_express.schema}.yaml
	rime_install_docs "${rime_cangjie}"/{AUTHORS,LICENSE,README.md}

	local rime_essay="${ESSAY_PN}-${ESSAY_COMMIT}"
	doins "$rime_essay"/essay.txt
	rime_install_docs "${rime_essay}"/{AUTHORS,LICENSE,README.md}

	local rime_luna_pinyin="${LUNA_PINYIN_PN}-${LUNA_PINYIN_COMMIT}"
	doins "${rime_luna_pinyin}"/{luna_quanpin.schema,pinyin}.yaml \
		"${rime_luna_pinyin}"/luna_pinyin{.dict,{,_fluency,_simp,_tw}.schema}.yaml
	rime_install_docs "${rime_luna_pinyin}"/{AUTHORS,LICENSE,README.md}

	local rime_prelude="${PRELUDE_PN}-${PRELUDE_COMMIT}"
	doins "${rime_prelude}"/{default,key_bindings,punctuation,symbols}.yaml
	rime_install_docs "${rime_prelude}"/{AUTHORS,LICENSE,README.md}

	local rime_stroke="${STROKE_PN}-${STROKE_COMMIT}"
	doins "${rime_stroke}"/stroke.{dict,schema}.yaml
	rime_install_docs "${rime_stroke}"/{AUTHORS,LICENSE,README.md}

	local rime_terra_pinyin="${TERRA_PINYIN_PN}-${TERRA_PINYIN_COMMIT}"
	doins "${rime_terra_pinyin}"/terra_pinyin.{dict,schema}.yaml
	rime_install_docs "${rime_terra_pinyin}"/{AUTHORS,LICENSE,README.md}

	if use extra; then
		local rime_array="${ARRAY_PN}-${ARRAY_COMMIT}"
		doins "${rime_array}"/array30{,_query,_wsymbols}.schema.yaml \
			"${rime_array}"/array30{,_emoji,_main,_phrases,_query,_wsymbols}.dict.yaml
		rime_install_docs "${rime_array}"/{AUTHORS,LICENSE,README.md}

		local rime_combo_pinyin="${COMBO_PINYIN_PN}-${COMBO_PINYIN_COMMIT}"
		doins "${rime_combo_pinyin}"/combo_pinyin{{,_{8,10}{,_emacsen},_9}.schema,_layouts}.yaml
		rime_install_docs "${rime_combo_pinyin}"/{AUTHORS,LICENSE,README.md}

		local rime_double_pinyin="${DOUBLE_PINYIN_PN}-${DOUBLE_PINYIN_COMMIT}"
		doins "${rime_double_pinyin}"/double_pinyin{,_abc,_flypy,_mspy,_pyjj}.schema.yaml
		rime_install_docs "${rime_double_pinyin}"/{AUTHORS,LICENSE,README.md}

		local rime_emoji="${EMOJI_PN}-${EMOJI_COMMIT}"
		doins "${rime_emoji}"/emoji_suggestion.yaml
		doins "${rime_emoji}"/opencc/emoji{_category.txt,_word.txt,.json}
		rime_install_docs "${rime_emoji}"/{AUTHORS,LICENSE,README.md}

		local rime_ipa="${IPA_PN}-${IPA_COMMIT}"
		doins "${rime_ipa}"/ipa_{xsampa,yunlong}.{dict,schema}.yaml
		rime_install_docs "${rime_ipa}"/{AUTHORS,LICENSE,README.md}

		local rime_middle_chinese="${MID_CHINESE_PN}-${MID_CHINESE_COMMIT}"
		doins "${rime_middle_chinese}"/{sampheng.schema,zyenpheng.{dict,schema}}.yaml
		rime_install_docs "${rime_middle_chinese}"/{AUTHORS,LICENSE,README.md}

		local rime_pinyin_simp="${PINYIN_SIMP_PN}-${PINYIN_SIMP_COMMIT}"
		doins "${rime_pinyin_simp}"/pinyin_simp.{dict,schema}.yaml
		rime_install_docs "${rime_pinyin_simp}"/{AUTHORS,LICENSE,README.md}

		local rime_quick="${QUICK_PN}-${QUICK_COMMIT}"
		doins "${rime_quick}"/quick5.{dict,schema}.yaml
		rime_install_docs "${rime_quick}"/{AUTHORS,LICENSE,README.md}

		local rime_scj="${SCJ_PN}-${SCJ_COMMIT}"
		doins "${rime_scj}"/scj6.{dict,schema}.yaml
		rime_install_docs "${rime_scj}"/{AUTHORS,LICENSE,README.md}

		local rime_soutzoe="${SOUTZOE_PN}-${SOUTZOE_COMMIT}"
		doins "${rime_soutzoe}"/soutzoe.{dict,schema}.yaml
		rime_install_docs "${rime_soutzoe}"/{AUTHORS,LICENSE,README.md}

		local rime_stenotype="${STENOTYPE_PN}-${STENOTYPE_COMMIT}"
		doins "${rime_stenotype}"/stenotype.schema.yaml
		rime_install_docs "${rime_stenotype}"/{AUTHORS,LICENSE,README.md}

		local rime_wubi="${WUBI_PN}-${WUBI_COMMIT}"
		doins "${rime_wubi}"/wubi{86.{dict,schema},_{pinyin,trad}.schema}.yaml
		rime_install_docs "${rime_wubi}"/{AUTHORS,LICENSE,README.md}

		local rime_wugniu="${WUGNIU_PN}-${WUGNIU_COMMIT}"
		doins "${rime_wugniu}"/wugniu{.schema,_lopha.{dict,schema}}.yaml
		rime_install_docs "${rime_wugniu}"/{AUTHORS,LICENSE,README.md}
	fi
}
