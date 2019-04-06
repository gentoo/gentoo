# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop

MY_PN="WebStorm"
MY_PV="$(ver_cut 1-2)"
MY_BN="$(ver_cut 3-5)"

DESCRIPTION="The powerful IDE for modern JavaScript development"
HOMEPAGE="http://www.jetbrains.com/webstorm"
SRC_URI="http://download.jetbrains.com/webstorm/${MY_PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

KEYWORDS="~amd64 ~x86"
SLOT="2019"
IUSE="custom-jdk"
RDEPEND="!custom-jdk? ( >=virtual/jre-1.8 )"

RESTRICT="splitdebug" #656858

S="${WORKDIR}/${MY_PN}-${MY_BN}"

src_prepare() {
	default

	declare -a remove_me

	use arm || remove_me+=( bin/fsnotifier-arm )
	use custom-jdk || remove_me+=( jre64 )

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{webstorm.sh,fsnotifier{,64}}

	if use custom-jdk; then
		if [[ -d jre64 ]]; then
			fperms 775 "${dir}"/jre64/bin/{clhsdb,hsdb,java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "${PN}" "${PN}" "Development;IDE;"
}
