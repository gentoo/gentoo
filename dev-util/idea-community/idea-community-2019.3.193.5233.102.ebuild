# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop

SLOT="0"
PV_STRING="$(ver_cut 3-6)"
MY_PV="$(ver_cut 1-2)"
MY_PN="idea"
# Using the most recent Jetbrains Runtime binaries available at the time of writing
# As the exact bundled versions ( jre 11 build 159.30 and jre 8 build 1483.39 ) aren't
# available separately
JRE11_BASE="11_0_2"
JRE11_VER="164"
JRE_BASE="8u202"
JRE_VER="1483.37"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 7)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS=""
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${MY_PV}-no-jbr.tar.gz -> ${MY_PN}IC-${PV_STRING}.tar.gz
		jbr8? ( x86? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz )
		amd64? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz ) )
		jbr11? ( amd64? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz -> jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz ) )"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
	codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0 jbr8? ( GPL-2 )
	jbr11? ( GPL-2 ) GPL-2 GPL-2-with-classpath-exception ISC
	JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
	MPL-1.0 MPL-1.1 OFL ZLIB"

#Splitting custom-jdk into jbr8 and jbr11 as upstream now offers downloads with
#either (or neither) bundled
#Defaulting to jbr8 to match upstream
IUSE="+jbr8 -jbr11"
REQUIRED_USE="jbr8? ( !jbr11 )"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"
RESTRICT="splitdebug"
S="${WORKDIR}/${MY_PN}-IC-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

# jbr11 binary doesn't unpack nicely into a single folder
src_unpack() {
if use !jbr11 ; then
default_src_unpack
else
cd "${WORKDIR}"
unpack ${MY_PN}IC-${PV_STRING}.tar.gz
cd "${S}"
mkdir jre64 && cd jre64 && unpack jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz
fi
}
src_prepare() {
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi
	if use jbr8; then
			mv "${WORKDIR}/jre" ./"${JRE_DIR}"
	fi
	eapply_user
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,printenv.py,restart.py,fsnotifier{,64}}
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi
	if use jbr8 || use jbr11 ; then
	if use jbr8; then
		JRE_BINARIES="java jjs keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200"
	else
		JRE_BINARIES="jaotc java javapackager jjs jrunscript keytool pack200 rmid rmiregistry unpack200"
	fi
		if [[ -d ${JRE_DIR} ]]; then
			for jrebin in $JRE_BINARIES; do
				fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
			done
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Community" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
