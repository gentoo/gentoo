# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans IDE"
HOMEPAGE="http://netbeans.org/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
PATCHES_URL="http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2"
L10N_URL="http://dev.gentoo.org/~fordfrog/distfiles/netbeans-l10n-8.2-20160920.tar.bz2"
ALL_URLS="${SOURCE_URL} ${PATCHES_URL} ${L10N_URL}"
SRC_URI="l10n_af? ( ${ALL_URLS} )
	l10n_ar? ( ${ALL_URLS} )
	l10n_bg? ( ${ALL_URLS} )
	l10n_ca? ( ${ALL_URLS} )
	l10n_cs? ( ${ALL_URLS} )
	l10n_de? ( ${ALL_URLS} )
	l10n_el? ( ${ALL_URLS} )
	l10n_es? ( ${ALL_URLS} )
	l10n_fil? ( ${ALL_URLS} )
	l10n_fr? ( ${ALL_URLS} )
	l10n_gl? ( ${ALL_URLS} )
	l10n_hi? ( ${ALL_URLS} )
	l10n_id? ( ${ALL_URLS} )
	l10n_it? ( ${ALL_URLS} )
	l10n_ja? ( ${ALL_URLS} )
	l10n_ko? ( ${ALL_URLS} )
	l10n_lt? ( ${ALL_URLS} )
	l10n_nl? ( ${ALL_URLS} )
	l10n_pl? ( ${ALL_URLS} )
	l10n_pt-BR? ( ${ALL_URLS} )
	l10n_pt-PT? ( ${ALL_URLS} )
	l10n_ro? ( ${ALL_URLS} )
	l10n_ru? ( ${ALL_URLS} )
	l10n_si? ( ${ALL_URLS} )
	l10n_sq? ( ${ALL_URLS} )
	l10n_sr? ( ${ALL_URLS} )
	l10n_sv? ( ${ALL_URLS} )
	l10n_ta? ( ${ALL_URLS} )
	l10n_tr? ( ${ALL_URLS} )
	l10n_vi? ( ${ALL_URLS} )
	l10n_zh-CN? ( ${ALL_URLS} )
	l10n_zh-TW? ( ${ALL_URLS} )
"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE_NETBEANS_MODULES="
	+netbeans_modules_apisupport
	netbeans_modules_cnd
	netbeans_modules_dlight
	netbeans_modules_enterprise
	netbeans_modules_ergonomics
	netbeans_modules_extide
	netbeans_modules_groovy
	+netbeans_modules_java
	netbeans_modules_javacard
	+netbeans_modules_javafx
	netbeans_modules_mobility
	netbeans_modules_php
	+netbeans_modules_profiler
	netbeans_modules_webcommon
	+netbeans_modules_websvccommon"
IUSE_L10N="
	l10n_af
	l10n_ar
	l10n_bg
	l10n_ca
	l10n_cs
	l10n_de
	l10n_el
	l10n_es
	l10n_fil
	l10n_fr
	l10n_gl
	l10n_hi
	l10n_id
	l10n_it
	l10n_ja
	l10n_ko
	l10n_lt
	l10n_nl
	l10n_pl
	l10n_pt-BR
	l10n_pt-PT
	l10n_ro
	l10n_ru
	l10n_si
	l10n_sq
	l10n_sr
	l10n_sv
	l10n_ta
	l10n_tr
	l10n_vi
	l10n_zh-CN
	l10n_zh-TW"
IUSE="doc ${IUSE_NETBEANS_MODULES} ${IUSE_L10N}"
S="${WORKDIR}"

DEPEND=">=virtual/jdk-1.7
	dev-java/javahelp:0"
RDEPEND="|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-nb-${PV}
	~dev-java/netbeans-platform-${PV}
	netbeans_modules_apisupport? ( ~dev-java/netbeans-apisupport-${PV} )
	netbeans_modules_cnd? ( ~dev-java/netbeans-cnd-${PV} )
	netbeans_modules_dlight? ( ~dev-java/netbeans-dlight-${PV} )
	netbeans_modules_enterprise? ( ~dev-java/netbeans-enterprise-${PV} )
	netbeans_modules_ergonomics? ( ~dev-java/netbeans-ergonomics-${PV} )
	netbeans_modules_extide? ( ~dev-java/netbeans-extide-${PV} )
	netbeans_modules_groovy? ( ~dev-java/netbeans-groovy-${PV} )
	netbeans_modules_java? ( ~dev-java/netbeans-java-${PV} )
	netbeans_modules_javacard? ( ~dev-java/netbeans-javacard-${PV} )
	netbeans_modules_javafx? ( ~dev-java/netbeans-javafx-${PV} )
	netbeans_modules_mobility? ( ~dev-java/netbeans-mobility-${PV} )
	netbeans_modules_php? ( ~dev-java/netbeans-php-${PV} )
	netbeans_modules_profiler? ( ~dev-java/netbeans-profiler-${PV} )
	netbeans_modules_webcommon? ( ~dev-java/netbeans-webcommon-${PV} )
	netbeans_modules_websvccommon? ( ~dev-java/netbeans-websvccommon-${PV} )
	doc? ( ~dev-java/netbeans-javadoc-${PV} )"

JAVA_PKG_BSFIX="off"
NBLOCALES=""

pkg_setup() {
	for lingua in ${IUSE_L10N} ; do
		if use ${lingua} ; then
			local lang=${lingua/l10n_/}
			lang=${lang/-/_}

			case ${lang} in
				ar)  lang="ar_EG,ar_SA" ;;
				es)  lang="es,es_CO"    ;;
				fil) lang="fil_PH"	;;
				gl)  lang="gl_ES"	;;
				hi)  lang="hi_IN"	;;
				id)  lang="in_ID"	;;
				nl)  lang="nl_BE,nl_NL" ;;
				ta)  lang="ta_IN"	;;
			esac

			if [ -z "${NBLOCALES}" ] ; then
				NBLOCALES="${lang}"
			else
				NBLOCALES="${NBLOCALES},${lang}"
			fi
		fi
	done

	java-pkg-2_pkg_setup
}

src_unpack() {
	if [ -n "${NBLOCALES}" ] ; then
		unpack $(basename ${SOURCE_URL})
		unpack $(basename ${L10N_URL})

		einfo "Deleting bundled jars..."
		find -name "*.jar" -type f -delete

		unpack netbeans-8.2-build.xml.patch.bz2
	fi
}

src_prepare() {
	if [ -n "${NBLOCALES}" ] ; then
		einfo "Deleting bundled class files..."
		find -name "*.class" -type f | xargs rm -vf

		epatch netbeans-8.2-build.xml.patch

		einfo "Symlinking external libraries..."
		java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	fi

	java-pkg-2_src_prepare
	default
}

src_compile() {
	if [ -n "${NBLOCALES}" ] ; then
		einfo "Compiling support for locales: ${NBLOCALES}"
		eant -f nbbuild/build.xml bootstrap || die
		eant -Dlocales=${NBLOCALES} -Ddist.dir=../nbbuild/netbeans -Dnbms.dir="" -Dnbms.dist.dir="" \
			-Dpermit.jdk7.builds=true -f l10n/build.xml build || die
	fi
}

src_install() {
	if [ -n "${NBLOCALES}" ] ; then
		pushd "${S}"/nbbuild/netbeans >/dev/null || die

		for cluster in apisupport cnd dlight enterprise ergonomics groovy harness ide java javacard javafx mobility php platform profiler webcommon websvccommon ; do
			if [ -d "${cluster}" ] ; then
				insinto /usr/share/netbeans-${cluster}-${SLOT}
				doins -r ${cluster}/*
			fi
		done

		if [ -d nb ] ; then
			insinto /usr/share/netbeans-nb-${SLOT}/nb
			doins -r nb/*
		fi

		popd >/dev/null || die

		make_desktop_entry "netbeans-${SLOT} --locale en" "Netbeans ${PV} en" netbeans-${SLOT} Development

		for lingua in ${IUSE_L10N}; do
			if use ${lingua} ; then
				local locales=${lingua/l10n_/}
				locales=${locales/-/:}

				case ${locales} in
					ar)  lang="ar:EG ar:SA" ;;
					es)  lang="es es:CO"    ;;
					fil) lang="fil:PH"	;;
					gl)  lang="gl:ES"	;;
					hi)  lang="hi:IN"	;;
					id)  lang="in:ID"	;;
					nl)  lang="nl:BE nl:NL" ;;
					ta)  lang="ta:IN"	;;
				esac

				for locale in ${locales}; do
					make_desktop_entry "netbeans-${SLOT} --locale ${locale}" "Netbeans ${PV} ${locale}" netbeans-${SLOT} Development
				done
			fi
		done
	fi
}
