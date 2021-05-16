# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implements the SongCast protocol for use by upmpdcli and mpd"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli/index.html"

openhome_packageversion="20200704"

SRC_URI="
	https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz
	https://www.lesbonscomptes.com/upmpdcli/downloads/openhome-sc2-${openhome_packageversion}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/expat
	media-libs/alsa-lib
	media-libs/libsamplerate
	media-libs/libmpdclient
	<=net-libs/libmicrohttpd-0.9.70
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${P}.tar.gz
	mkdir openhome || die "Can't create openhome directory"
	cd openhome || die "Can't enter openhome directory"
	unpack openhome-sc2-${openhome_packageversion}.tar.gz
}

src_prepare() {
	cd "${WORKDIR}" || die "Couldn't cd to WORKDIR"
	eapply "${FILESDIR}/${P}-python.patch"
	eapply "${FILESDIR}/${P}-werror.patch"
	eapply_user
}

src_configure() {
	econf "--with-openhome=${WORKDIR}/openhome"
}

src_compile() {

	#### Begin ohbuild.sh reverse engineer

	# build_ohNet
	cd "${WORKDIR}/openhome/ohNet" || die "Couldn't cd to ohNet dir"
	make native_only=yes || die "ohnet make failed"

	# build_ohNetGenerated
	cd "${WORKDIR}/openhome/ohNetGenerated" || die "Couldn't cd to ohNetGenerated dir"
	# TODO: get from environment/make target
	deps="${WORKDIR}/openhome/ohNetGenerated/dependencies/Linux-x64/ohNet-Linux-x64-Release"
	mkdir -p $deps/{include/ohnet,lib/{ohnet,t4,ui,PyOhNet}} || die "Couldn't mkdir deps"
	cd $deps || die "Couldn't cd to deps dir"

	ohnet="${WORKDIR}/openhome/ohNet"
	find "$ohnet/Build" \( -name '*.a' -o -name '*.so' \) \
		 -exec cp '{}' lib ';' \
		|| die "Couldn't cp binary libs"

	cd "$ohnet/Build/Include" || die "Couldn't cd to include"
	cp -R * "${deps}/include/ohnet" || die "Couldn't cp include"
	# cd "$ohnet/Build/Tools" || die "Couldn't cd to tools"
	# cp -R * "${deps}/lib/t4" || die "Couldn't cp tools"
	cd "$ohnet/OpenHome/Net/T4/Templates" || die "Couldn't cd to templates"
	cp -R * "${deps}/lib/t4" || die "Couldn't cp templates"
	cd "$ohnet/OpenHome/Net/Bindings/Js/ControlPoint" || die "Couldn't cd to ui"
	cp -R * "${deps}/lib/ui" || die "Couldn't cp ui"
	cd "$ohnet/OpenHome/Net/Bindings/Python/PyOhNet" || die "Couldn't cd to py"
	cp -R * "${deps}/lib/PyOhNet" || die "Couldn't cp py"

	cd "${WORKDIR}/openhome/ohNetGenerated" || die "Couldn't cd later to ohNetGenerated dir"
	make native_only=yes || die "ohnetgenerated make failed"

	cd "Build/Include" || die "Couldn't cd later to include"
	cp -R * "$ohnet/Build/Include" || die "Couldn't cp generated includes"

	# build_ohTopology
	cd "${WORKDIR}/openhome/ohTopology" || die "Couldn't cd to ohTopology dir"
	mkdir -p build/Include/OpenHome/Av || die "Couldn't mkdir av"
	cp -p OpenHome/Av/*.h build/Include/OpenHome/Av/ || die "Couldn't cp to av"

	# build_ohSongcast
	cd "${WORKDIR}/openhome/ohSongcast" || die "Couldn't cd to ohSongcast dir"
	make release=1 library_static || die "Failed to build ohSongcast"

	#### End ohbuild.sh reverse engineer

	cd "${S}" || die "Failed to cd to source directory"
	make || die "Failed to make sc2mpd"
}
