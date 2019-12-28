# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mono-env xdg-utils

MY_PV=release-${PV}
#MY_PV=playtest-${PV}

DESCRIPTION="A free RTS engine supporting games like Command & Conquer, Red Alert and Dune2k"
HOMEPAGE="https://www.openra.net/"

# This sed one-liner was used to generate the SRC_URI list
# below. Ideally we would package these DLLs separately instead but
# Gentoo Dotnet doesn't seem to be in great shape right now.
#
# sed -n -r -e 's@.*curl.*(https:[^ ]+/([^/]+)/([^.]+)([^ ]+)).*@\1 -> \3-\2\4@p' \
#           -e 's@.*noget\.sh ([^ ]+) ([^ ]+).*@https://www.nuget.org/api/v2/package/\1/\2 -> \1-\2.zip@p' \
#           "${S}"/thirdparty/fetch-thirdparty-deps.sh | grep -v 'NUnit\|StyleCop' | sort

SRC_URI="https://github.com/OpenRA/OpenRA/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenRA/Eluant/releases/download/20160124/Eluant.dll -> Eluant-20160124.dll
	https://github.com/OpenRA/OpenAL-CS/releases/download/20151227/OpenAL-CS.dll.config -> OpenAL-CS-20151227.dll.config
	https://github.com/OpenRA/OpenAL-CS/releases/download/20151227/OpenAL-CS.dll -> OpenAL-CS-20151227.dll
	https://github.com/OpenRA/SDL2-CS/releases/download/20161223/SDL2-CS.dll.config -> SDL2-CS-20161223.dll.config
	https://github.com/OpenRA/SDL2-CS/releases/download/20161223/SDL2-CS.dll -> SDL2-CS-20161223.dll
	https://www.nuget.org/api/v2/package/FuzzyLogicLibrary/1.2.0 -> FuzzyLogicLibrary-1.2.0.zip
	https://www.nuget.org/api/v2/package/MaxMind.Db/2.0.0 -> MaxMind.Db-2.0.0.zip
	https://www.nuget.org/api/v2/package/Open.Nat/2.1.0 -> Open.Nat-2.1.0.zip
	https://www.nuget.org/api/v2/package/rix0rrr.BeaconLib/1.0.1 -> rix0rrr.BeaconLib-1.0.1.zip
	https://www.nuget.org/api/v2/package/SharpFont/4.0.1 -> SharpFont-4.0.1.zip
	https://www.nuget.org/api/v2/package/SharpZipLib/0.86.0 -> SharpZipLib-0.86.0.zip"

# Engine is GPL-3, dependent DLLs are mixed.
LICENSE="GPL-3 Apache-2.0 BSD GPL-2 MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug geoip"
RESTRICT="mirror test"

BDEPEND=">=dev-lang/mono-4.2"

DEPEND="${BDEPEND}
	dev-dotnet/libgdiplus"

RDEPEND="${DEPEND}
	app-misc/ca-certificates
	=dev-lang/lua-5.1*:0
	media-libs/freetype:2
	media-libs/libsdl2[opengl,video]
	media-libs/openal
	geoip? ( net-misc/geoipupdate )"

S="${WORKDIR}/OpenRA-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-system-geoip.patch
)

DOCS=(
	AUTHORS
	CODE_OF_CONDUCT.md
	CONTRIBUTING.md
	README.md
)

src_unpack() {
	local DOWNLOADS="${S}"/thirdparty/download
	mkdir -p "${DOWNLOADS}" || die

	# Stub out unnecessary development dependencies.
	touch "${DOWNLOADS}"/{{nunit.framework,StyleCop{,Plus}}.dll,nunit3-console.exe} || die

	for a in ${A}; do
		case ${a} in
			# Unpack engine sources.
			${P}.tar.gz) unpack ${a} ;;

			# Symlink other downloads, Makefile will extract and copy.
			*) ln -snf "${DISTDIR}/${a}" "${DOWNLOADS}/${a%-[0-9]*}${a##*[0-9]}" || die ;;
		esac
	done
}

src_prepare() {
	# Stub out attempts to download anything.
	sed -i -r 's/^\s*(curl|wget)\b/: #\1/' thirdparty/{fetch-thirdparty-deps,noget}.sh || die

	# Extract what is needed from the downloads.
	emake cli-dependencies

	default
}

src_compile() {
	emake $(usex debug "" DEBUG=false)
	emake VERSION=${MY_PV} version man-page
}

src_install() {
	emake $(usex debug "" DEBUG=false) \
		prefix="${EPREFIX}"/usr \
		gameinstalldir='$(prefix)'/share/${PN} \
		DESTDIR="${D}" \
		VERSION=${MY_PV} \
		install \
		install-linux-mime \
		install-linux-shortcuts \
		install-man-page

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	if [[ ! -s ${EROOT}/usr/share/GeoIP/GeoLite2-Country.mmdb ]]; then
		echo
		ewarn "Multiplayer server locations will show as unknown until you install"

		if use geoip; then
			ewarn "a GeoIP database. Run emerge --config ${CATEGORY}/${PN}"
			ewarn "occasionally to fetch one and keep it current."
		else
			ewarn "a GeoIP database. Start by enabling the geoip USE flag."
		fi
	fi

	if [[ ! -d ${EROOT}/usr/share/.mono/certs ]]; then
		echo
		ewarn "The multiplayer server listing will not work at all until you install"
		ewarn "CA certificates using Mono's cert-sync. Run emerge --config"
		ewarn "${CATEGORY}/${PN} occasionally to set them up and keep them"
		ewarn "current."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_config() {
	if use geoip; then
		ebegin "Updating GeoIP database"
		geoipupdate -d "${EROOT}"/usr/share/GeoIP
		eend $?
	fi

	ebegin "Updating Mono CA certificates"
	cert-sync --quiet "${EROOT}"/etc/ssl/certs/ca-certificates.crt
	eend $?

	if [[ -n ${ROOT%/} ]]; then
		echo
		ewarn "Mono's cert-sync cannot write to your ROOT system so you must manually"
		ewarn "copy the certificates from ${BROOT}/usr/share/.mono to ${EROOT}/usr/share/.mono."
	fi
}
