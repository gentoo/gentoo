# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop

SLOT="0"
PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="idea"
JRE_BASE="8u202"
JRE_VER="1483.24"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 7)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS=""
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${MY_PV}-no-jdk.tar.gz -> ${MY_PN}IC-${PV_STRING}.tar.gz
	custom-jdk? ( x86? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz )
			amd64? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz ) )"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="Apache-2.0
	custom-jdk? ( GPL-2 )"
IUSE="-custom-jdk"
DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"
S="${WORKDIR}/${MY_PN}-IC-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_prepare() {
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi
	if use custom-jdk; then
			mv "${WORKDIR}/jre" ./"${JRE_DIR}"
	fi
	if ! use arm; then
		rm bin/fsnotifier-arm || die
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
	if use custom-jdk; then
		if [[ -d ${JRE_DIR} ]]; then
		fperms 755 "${dir}"/"${JRE_DIR}"/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Community" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
