# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="All the unlocked modules for app-text/sword, grouped by language"
HOMEPAGE="https://www.crosswire.org/sword/modules/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

LANGS=" af ar az be bea bg bla br ch chr ckb cop cs cu cy da de el en eo es et eu fa fi fr ga gd gez got grc gv he hi hr ht hu hy it ja kek kk km ko kpg ktu la ln lt lv mg mi ml mn my nb nd nl nn pl pon pot ppk prs pt rmq ro ru sl sml sn so sq sr sv sw syr th tl tlh tr tsg ug uk ur vi vls zh"
IUSE="esoteric ${LANGS// / l10n_}"

RDEPEND="
	|| ( app-dicts/sword-Eusebian_num app-dicts/sword-Eusebian_vs )
	app-dicts/sword-Personal
	esoteric? (
		app-dicts/sword-Phaistos
		app-dicts/sword-Sentiment
	)
	l10n_af? (
		app-dicts/sword-Afr1953
	)
	l10n_ar? (
		app-dicts/sword-AraNAV
		app-dicts/sword-AraSVD
		app-dicts/sword-alzat
	)
	l10n_az? (
		app-dicts/sword-Azeri
		app-dicts/sword-NorthernAzeri
	)
	l10n_be? (
		app-dicts/sword-Bela
	)
	l10n_bea? (
		app-dicts/sword-BeaMRK
	)
	l10n_bg? (
		app-dicts/sword-BulVeren
	)
	l10n_bla? (
		app-dicts/sword-BlaMat
	)
	l10n_br? (
		app-dicts/sword-BretonNT
		app-dicts/sword-br_en
	)
	l10n_ch? (
		app-dicts/sword-Chamorro
	)
	l10n_chr? (
		app-dicts/sword-Che1860
	)
	l10n_ckb? (
		app-dicts/sword-Sorani
	)
	l10n_cop? (
		app-dicts/sword-CopNT
		app-dicts/sword-CopSahBible2
		app-dicts/sword-CopSahHorner
		app-dicts/sword-CopSahidicMSS
		app-dicts/sword-CopSahidica
		app-dicts/sword-SahidicBible
	)
	l10n_cs? (
		app-dicts/sword-CzeB21
		app-dicts/sword-CzeBKR
		app-dicts/sword-CzeCEP
		app-dicts/sword-CzeCSP
	)
	l10n_cu? (
		app-dicts/sword-CSlElizabeth
	)
	l10n_cy? (
		app-dicts/sword-WelBeiblNet
	)
	l10n_da? (
		app-dicts/sword-DaNT1819
		app-dicts/sword-DaOT1871NT1907
		app-dicts/sword-DaOT1931NT1907
	)
	l10n_de? (
		app-dicts/sword-GerAlbrecht
		app-dicts/sword-GerAugustinus
		app-dicts/sword-GerBoLut
		app-dicts/sword-GerElb1871
		app-dicts/sword-GerElb1905
		app-dicts/sword-GerGruenewald
		app-dicts/sword-GerKingComm
		app-dicts/sword-GerLeoNA28
		app-dicts/sword-GerLeoRP18
		app-dicts/sword-GerLut1545
		app-dicts/sword-GerLutherpredigten
		app-dicts/sword-GerMenge
		app-dicts/sword-GerNeUe
		app-dicts/sword-GerOffBiSt
		app-dicts/sword-GerReinhardt
		app-dicts/sword-GerSch
		app-dicts/sword-GerTafel
		app-dicts/sword-GerTextbibel
		app-dicts/sword-GerZurcher
		app-dicts/sword-MAK
		app-dicts/sword-Rieger
	)
	l10n_el? (
		app-dicts/sword-GreVamvas
	)
	l10n_en? (
		app-dicts/sword-2BabDict
		app-dicts/sword-AB
		app-dicts/sword-ABP
		app-dicts/sword-ABS_Essay_GoodSam_SWB
		app-dicts/sword-ACV
		app-dicts/sword-AKJV
		app-dicts/sword-ASV
		app-dicts/sword-Abbott
		app-dicts/sword-AbbottSmith
		app-dicts/sword-AbbottSmithStrongs
		app-dicts/sword-AmTract
		app-dicts/sword-Anderson
		app-dicts/sword-BBE
		app-dicts/sword-BDBGlosses_Strongs
		app-dicts/sword-BWE
		app-dicts/sword-BaptistConfession1689
		app-dicts/sword-Barnes
		app-dicts/sword-Burkitt
		app-dicts/sword-CBC
		app-dicts/sword-CPDV
		app-dicts/sword-Catena
		app-dicts/sword-Cawdrey
		app-dicts/sword-Clarke
		app-dicts/sword-Common
		app-dicts/sword-Concord
		app-dicts/sword-DBD
		app-dicts/sword-DRC
		app-dicts/sword-DTN
		app-dicts/sword-Daily
		app-dicts/sword-Darby
		app-dicts/sword-DarkNightOfTheSoul
		app-dicts/sword-Diaglott
		app-dicts/sword-Dodson
		app-dicts/sword-EMBReality
		app-dicts/sword-EMTV
		app-dicts/sword-Easton
		app-dicts/sword-Etheridge
		app-dicts/sword-Family
		app-dicts/sword-Finney
		app-dicts/sword-Geneva
		app-dicts/sword-Geneva1599
		app-dicts/sword-Godbey
		app-dicts/sword-GodsWord
		app-dicts/sword-Heretics
		app-dicts/sword-Hitchcock
		app-dicts/sword-ISBE
		app-dicts/sword-ISV
		app-dicts/sword-Imitation
		app-dicts/sword-Institutes
		app-dicts/sword-JCRHoliness
		app-dicts/sword-JEAffections
		app-dicts/sword-JESermons
		app-dicts/sword-JFB
		app-dicts/sword-JOChrist
		app-dicts/sword-JOCommGod
		app-dicts/sword-JOGlory
		app-dicts/sword-JOMortSin
		app-dicts/sword-JPS
		app-dicts/sword-JST
		app-dicts/sword-Josephus
		app-dicts/sword-Jubilee2000
		app-dicts/sword-KD
		app-dicts/sword-KJV
		app-dicts/sword-KJVA
		app-dicts/sword-KJVPCE
		app-dicts/sword-LEB
		app-dicts/sword-LITV
		app-dicts/sword-LO
		app-dicts/sword-LawGospel
		app-dicts/sword-Leeser
		app-dicts/sword-Lightfoot
		app-dicts/sword-Luther
		app-dicts/sword-MHC
		app-dicts/sword-MHCC
		app-dicts/sword-MKJV
		app-dicts/sword-MLStrong
		app-dicts/sword-MollColossians
		app-dicts/sword-Montgomery
		app-dicts/sword-Murdock
		app-dicts/sword-NETfree
		app-dicts/sword-NETnotesfree
		app-dicts/sword-NETtext
		app-dicts/sword-NHEB
		app-dicts/sword-NHEBJE
		app-dicts/sword-NHEBME
		app-dicts/sword-Nave
		app-dicts/sword-Noyes
		app-dicts/sword-OEB
		app-dicts/sword-OEBcth
		app-dicts/sword-OSHM
		app-dicts/sword-OrthJBC
		app-dicts/sword-Orthodoxy
		app-dicts/sword-PNT
		app-dicts/sword-Packard
		app-dicts/sword-Passion
		app-dicts/sword-Pilgrim
		app-dicts/sword-Practice
		app-dicts/sword-QuotingPassages
		app-dicts/sword-RKJNT
		app-dicts/sword-RNKJV
		app-dicts/sword-RWP
		app-dicts/sword-RWebster
		app-dicts/sword-RecVer
		app-dicts/sword-Robinson
		app-dicts/sword-Rotherham
		app-dicts/sword-SAOA
		app-dicts/sword-SME
		app-dicts/sword-SPE
		app-dicts/sword-Scofield
		app-dicts/sword-Smith
		app-dicts/sword-Spurious
		app-dicts/sword-StrongsGreek
		app-dicts/sword-StrongsHebrew
		app-dicts/sword-TCR
		app-dicts/sword-TDavid
		app-dicts/sword-TFG
		app-dicts/sword-TSK
		app-dicts/sword-Torrey
		app-dicts/sword-Twenty
		app-dicts/sword-Tyndale
		app-dicts/sword-UKJV
		app-dicts/sword-Webster
		app-dicts/sword-Webster1806
		app-dicts/sword-Webster1913
		app-dicts/sword-Wesley
		app-dicts/sword-Westminster
		app-dicts/sword-Westminster21
		app-dicts/sword-Weymouth
		app-dicts/sword-Worsley
		app-dicts/sword-Wycliffe
		app-dicts/sword-YLT
	)
	l10n_eo? (
		app-dicts/sword-Esperanto
	)
	l10n_es? (
		app-dicts/sword-SpaPlatense
		app-dicts/sword-SpaRV
		app-dicts/sword-SpaRV1865
		app-dicts/sword-SpaRV1909
		app-dicts/sword-SpaRVG
		app-dicts/sword-SpaTDP
		app-dicts/sword-SpaVNT
	)
	l10n_et? (
		app-dicts/sword-Est
	)
	l10n_eu? (
		app-dicts/sword-BasHautin
		app-dicts/sword-en_eu
	)
	l10n_fa? (
		app-dicts/sword-FarHezareNoh
		app-dicts/sword-FarOPV
		app-dicts/sword-FarTPV
	)
	l10n_fi? (
		app-dicts/sword-FinBiblia
		app-dicts/sword-FinPR
		app-dicts/sword-FinPR92
		app-dicts/sword-FinRK
		app-dicts/sword-FinSTLK2017
	)
	l10n_fr? (
		app-dicts/sword-FreBBB
		app-dicts/sword-FreBDM1707
		app-dicts/sword-FreBDM1744
		app-dicts/sword-FreBailly
		app-dicts/sword-FreCJE
		app-dicts/sword-FreCrampon
		app-dicts/sword-FreDAW
		app-dicts/sword-FreGBM
		app-dicts/sword-FreGeneve1669
		app-dicts/sword-FreJND
		app-dicts/sword-FreKhan
		app-dicts/sword-FreLSN1872
		app-dicts/sword-FreLXX
		app-dicts/sword-FreOltramare1874
		app-dicts/sword-FrePGR
		app-dicts/sword-FrePilgrim
		app-dicts/sword-FreSegond1910
		app-dicts/sword-FreStapfer1889
		app-dicts/sword-FreSynodale1921
	)
	l10n_ga? (
		app-dicts/sword-IriODomhnuill
	)
	l10n_gd? (
		app-dicts/sword-ScotsGaelic
	)
	l10n_gez? (
		app-dicts/sword-Geez
	)
	l10n_got? (
		app-dicts/sword-Wulfila
	)
	l10n_grc? (
		app-dicts/sword-ABPGRK
		app-dicts/sword-Antoniades
		app-dicts/sword-Byz
		app-dicts/sword-Elzevir
		app-dicts/sword-GreekHebrew
		app-dicts/sword-LXX
		app-dicts/sword-MorphGNT
		app-dicts/sword-Nestle1904
		app-dicts/sword-OxfordTR
		app-dicts/sword-SBLGNT
		app-dicts/sword-SBLGNTApp
		app-dicts/sword-TNT
		app-dicts/sword-TR
		app-dicts/sword-Tisch
		app-dicts/sword-VarApp
		app-dicts/sword-WHNU
		app-dicts/sword-f35
	)
	l10n_gv? (
		app-dicts/sword-ManxGaelic
	)
	l10n_he? (
		app-dicts/sword-Aleppo
		app-dicts/sword-HebDelitzsch
		app-dicts/sword-HebModern
		app-dicts/sword-HebrewGreek
		app-dicts/sword-MapM
		app-dicts/sword-OSHB
		app-dicts/sword-SP
		app-dicts/sword-SPDSS
		app-dicts/sword-SPMT
		app-dicts/sword-SPVar
		app-dicts/sword-WLC
	)
	l10n_hi? (
		app-dicts/sword-HinERV
	)
	l10n_hr? (
		app-dicts/sword-CroSaric
	)
	l10n_ht? (
		app-dicts/sword-Haitian
	)
	l10n_hu? (
		app-dicts/sword-HunIMIT
		app-dicts/sword-HunKNB
		app-dicts/sword-HunKar
		app-dicts/sword-HunUj
	)
	l10n_hy? (
		app-dicts/sword-ArmEastern
		app-dicts/sword-ArmWestern
	)
	l10n_it? (
		app-dicts/sword-ItDizGreco
		app-dicts/sword-ItNomiBibbia
		app-dicts/sword-ItaDio
		app-dicts/sword-ItaRive
	)
	l10n_ja? (
		app-dicts/sword-JapBungo
		app-dicts/sword-JapDenmo
		app-dicts/sword-JapKougo
		app-dicts/sword-JapMeiji
		app-dicts/sword-JapRaguet
	)
	l10n_kek? (
		app-dicts/sword-Kekchi
	)
	l10n_kk? (
		app-dicts/sword-Kaz
	)
	l10n_km? (
		app-dicts/sword-KhmerNT
	)
	l10n_ko? (
		app-dicts/sword-KorHKJV
		app-dicts/sword-KorRV
	)
	l10n_kpg? (
		app-dicts/sword-Kapingamarangi
	)
	l10n_ktu? (
		app-dicts/sword-KtuVb
	)
	l10n_la? (
		app-dicts/sword-VulgClementine
		app-dicts/sword-VulgConte
		app-dicts/sword-VulgGlossa
		app-dicts/sword-VulgHetzenauer
		app-dicts/sword-VulgSistine
		app-dicts/sword-Vulgate
		app-dicts/sword-Vulgate_HebPs
		app-dicts/sword-la_en
	)
	l10n_ln? (
		app-dicts/sword-LinVB
	)
	l10n_lt? (
		app-dicts/sword-LtKBB
	)
	l10n_lv? (
		app-dicts/sword-Latvian
		app-dicts/sword-LvGluck8
	)
	l10n_mg? (
		app-dicts/sword-Mg1865
	)
	l10n_mi? (
		app-dicts/sword-Maori
	)
	l10n_ml? (
		app-dicts/sword-Mal1910
	)
	l10n_mn? (
		app-dicts/sword-MonKJV
	)
	l10n_my? (
		app-dicts/sword-BurCBCM
		app-dicts/sword-BurJudson
	)
	l10n_nb? (
		app-dicts/sword-NorBroed
		app-dicts/sword-Norsk
	)
	l10n_nd? (
		app-dicts/sword-Ndebele
	)
	l10n_nl? (
		app-dicts/sword-DutKant
		app-dicts/sword-DutKingComm
		app-dicts/sword-DutSVV
		app-dicts/sword-DutSVVA
		app-dicts/sword-NlCanisius1939
	)
	l10n_nn? (
		app-dicts/sword-NorSMB
	)
	l10n_pl? (
		app-dicts/sword-PolGdanska
		app-dicts/sword-PolUGdanska
	)
	l10n_pon? (
		app-dicts/sword-PohnOld
		app-dicts/sword-Pohnpeian
	)
	l10n_pot? (
		app-dicts/sword-PotLykins
	)
	l10n_ppk? (
		app-dicts/sword-Uma
	)
	l10n_prs? (
		app-dicts/sword-Dari
	)
	l10n_pt? (
		app-dicts/sword-PorAR
		app-dicts/sword-PorAlmeida1911
		app-dicts/sword-PorBLivre
		app-dicts/sword-PorBLivreTR
		app-dicts/sword-PorCap
		app-dicts/sword-PorIBP
	)
	l10n_rmq? (
		app-dicts/sword-Calo
	)
	l10n_ro? (
		app-dicts/sword-RomCor
	)
	l10n_ru? (
		app-dicts/sword-RusCARS
		app-dicts/sword-RusCARSA
		app-dicts/sword-RusCARSADICT
		app-dicts/sword-RusCARSDict
		app-dicts/sword-RusCARST
		app-dicts/sword-RusCARSTDICT
		app-dicts/sword-RusMakarij
		app-dicts/sword-RusSynodal
		app-dicts/sword-RusSynodalLIO
		app-dicts/sword-RusVZh
	)
	l10n_sl? (
		app-dicts/sword-SloKJV
		app-dicts/sword-SloOjacano
		app-dicts/sword-SloStritar
	)
	l10n_sml? (
		app-dicts/sword-sml_BL_2008
	)
	l10n_sn? (
		app-dicts/sword-Shona
	)
	l10n_so? (
		app-dicts/sword-SomKQA
	)
	l10n_sq? (
		app-dicts/sword-Alb
	)
	l10n_sr? (
		app-dicts/sword-SrKDEkavski
		app-dicts/sword-SrKDIjekav
	)
	l10n_sv? (
		app-dicts/sword-Swe1917
		app-dicts/sword-Swe1917Of
		app-dicts/sword-SweFolk1998
		app-dicts/sword-SweKarlXII
		app-dicts/sword-SweKarlXII1873
	)
	l10n_sw? (
		app-dicts/sword-Swahili
	)
	l10n_syr? (
		app-dicts/sword-Peshitta
	)
	l10n_th? (
		app-dicts/sword-ThaiKJV
	)
	l10n_tl? (
		app-dicts/sword-TagAngBiblia
		app-dicts/sword-Tagalog
	)
	l10n_tlh? (
		app-dicts/sword-KLV
		app-dicts/sword-KLVen_iklingon
		app-dicts/sword-KLViklingon_en
	)
	l10n_tr? (
		app-dicts/sword-TurHADI
		app-dicts/sword-TurNTB
	)
	l10n_tsg? (
		app-dicts/sword-Tausug
	)
	l10n_ug? (
		app-dicts/sword-UyCyr
	)
	l10n_uk? (
		app-dicts/sword-UkrKulish
		app-dicts/sword-Ukrainian
	)
	l10n_ur? (
		app-dicts/sword-UrduGeo
		app-dicts/sword-UrduGeoDeva
		app-dicts/sword-UrduGeoRoman
	)
	l10n_vi? (
		app-dicts/sword-FVDPVietAnh
		app-dicts/sword-VieRobinson
		app-dicts/sword-VieStrongsGreek
		app-dicts/sword-Viet
		app-dicts/sword-VietLCCMN
		app-dicts/sword-VietLCCMNCT
		app-dicts/sword-VietNVB
	)
	l10n_vls? (
		app-dicts/sword-vlsJoNT
	)
	l10n_zh? (
		app-dicts/sword-ChiNCVs
		app-dicts/sword-ChiNCVt
		app-dicts/sword-ChiSB
		app-dicts/sword-ChiUn
		app-dicts/sword-ChiUnL
		app-dicts/sword-ChiUns
		app-dicts/sword-ZhEnglish
		app-dicts/sword-ZhHanzi
		app-dicts/sword-ZhPinyin
	)
"
