# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-8.0.2.ebuild,v 1.4 2015/05/21 09:52:11 ago Exp $

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans IDE"
HOMEPAGE="http://netbeans.org/"
SLOT="8.0"
SOURCE_URL="http://download.netbeans.org/netbeans/8.0.2/final/zip/netbeans-8.0.2-201411181905-src.zip"
PATCHES_URL="http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.0.2-build.xml.patch.bz2"
L10N_URL="http://dev.gentoo.org/~fordfrog/distfiles/netbeans-l10n-8.0.1-20141110.tar.bz2"
ALL_URLS="${SOURCE_URL} ${PATCHES_URL} ${L10N_URL}"
SRC_URI="linguas_af? ( ${ALL_URLS} )
	linguas_ar? ( ${ALL_URLS} )
	linguas_bg? ( ${ALL_URLS} )
	linguas_ca? ( ${ALL_URLS} )
	linguas_cs? ( ${ALL_URLS} )
	linguas_de? ( ${ALL_URLS} )
	linguas_el? ( ${ALL_URLS} )
	linguas_es? ( ${ALL_URLS} )
	linguas_fr? ( ${ALL_URLS} )
	linguas_gl? ( ${ALL_URLS} )
	linguas_hi_IN? ( ${ALL_URLS} )
	linguas_id? ( ${ALL_URLS} )
	linguas_it? ( ${ALL_URLS} )
	linguas_ja? ( ${ALL_URLS} )
	linguas_ko? ( ${ALL_URLS} )
	linguas_lt? ( ${ALL_URLS} )
	linguas_nl? ( ${ALL_URLS} )
	linguas_pl? ( ${ALL_URLS} )
	linguas_pt_BR? ( ${ALL_URLS} )
	linguas_pt_PT? ( ${ALL_URLS} )
	linguas_ro? ( ${ALL_URLS} )
	linguas_ru? ( ${ALL_URLS} )
	linguas_si? ( ${ALL_URLS} )
	linguas_sq? ( ${ALL_URLS} )
	linguas_sr? ( ${ALL_URLS} )
	linguas_sv? ( ${ALL_URLS} )
	linguas_ta_IN? ( ${ALL_URLS} )
	linguas_tl? ( ${ALL_URLS} )
	linguas_tr? ( ${ALL_URLS} )
	linguas_vi? ( ${ALL_URLS} )
	linguas_zh_CN? ( ${ALL_URLS} )
	linguas_zh_TW? ( ${ALL_URLS} )
"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 x86"
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
IUSE_LINGUAS="
	linguas_af
	linguas_ar
	linguas_bg
	linguas_ca
	linguas_cs
	linguas_de
	linguas_el
	linguas_es
	linguas_fr
	linguas_gl
	linguas_hi_IN
	linguas_id
	linguas_it
	linguas_ja
	linguas_ko
	linguas_lt
	linguas_nl
	linguas_pl
	linguas_pt_BR
	linguas_pt_PT
	linguas_ro
	linguas_ru
	linguas_si
	linguas_sq
	linguas_sr
	linguas_sv
	linguas_ta_IN
	linguas_tl
	linguas_tr
	linguas_vi
	linguas_zh_CN
	linguas_zh_TW"
IUSE="doc ${IUSE_NETBEANS_MODULES} ${IUSE_LINGUAS}"
S="${WORKDIR}"

DEPEND="virtual/jdk:1.7
	dev-java/javahelp:0"
RDEPEND=">=virtual/jdk-1.7
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
	for lingua in ${IUSE_LINGUAS} ; do
		local lang=${lingua/linguas_/}

		if [[ "${lang}" = "ar" ]] ; then
			lang="ar_EG,ar_SA"
		elif [[ "${lang}" = "es" ]] ; then
			lang="es,es_CO"
		elif [[ "${lang}" = "gl" ]] ; then
			lang="gl_ES"
		elif [[ "${lang}" = "id" ]] ; then
			lang="in_ID"
		elif [[ "${lang}" = "nl" ]] ; then
			lang="nl_BE,nl_NL"
		elif [[ "${lang}" = "tl" ]] ; then
			lang="fil_PH"
		fi

		if use ${lingua} ; then
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

		unpack netbeans-8.0.2-build.xml.patch.bz2
	fi
}

src_prepare() {
	if [ -n "${NBLOCALES}" ] ; then
		einfo "Deleting bundled class files..."
		find -name "*.class" -type f | xargs rm -vf

		epatch netbeans-8.0.2-build.xml.patch

		# Support for custom patches
		if [ -n "${NETBEANS80_PATCHES_DIR}" -a -d "${NETBEANS80_PATCHES_DIR}" ] ; then
			local files=`find "${NETBEANS80_PATCHES_DIR}" -type f`

			if [ -n "${files}" ] ; then
				einfo "Applying custom patches:"

				for file in ${files} ; do
					epatch "${file}"
				done
			fi
		fi

		einfo "Symlinking external libraries..."
		java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	fi

	java-pkg-2_src_prepare
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
	fi
}

pkg_postinst() {
	if [ -n "${NBLOCALES}" ] ; then
		einfo "Netbeans automatically starts with the locale you have set in your user profile, if"
		einfo "the locale is built for Netbeans."
		einfo "If you want to force specific locale, use --locale argument, for example:"
		einfo "${PN}-${SLOT} --locale de"
		einfo "${PN}-${SLOT} --locale pt:BR"
	fi

	if use linguas_ar ; then
		einfo
		einfo "You selected Arabic locale so you can choose either ar:EG or ar:SA variant."
	fi

	if use linguas_es ; then
		einfo
		einfo "You selected Spanish locale so you can choose either es or es:CO variant."
	fi

	if use linguas_gl ; then
		einfo
		einfo "You selected Galician locale which has locale code gl:ES in Netbeans."
	fi

	if use linguas_id ; then
		einfo
		einfo "You selected Indonesian locale which has locale code in:ID in Netbeans."
	fi

	if use linguas_nl ; then
		einfo
		einfo "You selected Dutch locale so you can choose either nl:BE or nl:NL variant."
	fi

	if use linguas_tl ; then
		einfo
		einfo "You selected Tagalog locale which has for Filipino locale code fil:PH in Netbeans."
	fi
}
