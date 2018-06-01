# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Implements the SongCast protocol for use by upmpdcli and mpd"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli/index.html"

sha_net="1dd6411ffbe59fe09517162fb88e2405adb4990f"
sha_netgenerated="e3edb912410d4c5a4d5323bb1e9c27660a42d78f"
sha_topology="cc09c09da4be8d3d04adae5b8f0daaf8450906a3"
sha_songcast="3299eaedfea34993b79e6d30444792d4fb12a110"
sha_devtools="d3586187dfa5f0a8b0f3e35e3d1dc50d1c34943d"

SRC_URI="
	https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz
	https://codeload.github.com/openhome/ohNet/tar.gz/${sha_net}
		-> ohnet.${sha_net:0:6}.tar.gz
	https://codeload.github.com/openhome/ohNetGenerated/tar.gz/${sha_netgenerated}
		-> ohnetgenerated.${sha_netgenerated:0:6}.tar.gz
	https://codeload.github.com/openhome/ohTopology/tar.gz/${sha_topology}
		-> ohtopology.${sha_topology:0:6}.tar.gz
	https://codeload.github.com/openhome/ohSongcast/tar.gz/${sha_songcast}
		-> ohsongcast.${sha_songcast:0:6}.tar.gz
	https://codeload.github.com/openhome/ohdevtools/tar.gz/${sha_devtools}
		-> ohdevtools.${sha_devtools:0:6}.tar.gz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/alsa-lib
	media-libs/libsamplerate
	net-libs/libmicrohttpd
"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${WORKDIR}" || die "Couldn't cd to WORKDIR"
	mkdir openhome || die "Couldn't mkdir openhome"
	mv ohNet-${sha_net} openhome/ohNet || die "Couldn't mv ohNet"
	mv ohNetGenerated-${sha_netgenerated} openhome/ohNetGenerated || die "Couldn't mv ohNetGenerated"
	mv ohdevtools-${sha_devtools} openhome/ohdevtools || die "Couldn't mv ohdevtools"
	mv ohTopology-${sha_topology} openhome/ohTopology || die "Couldn't mv ohTopology"
	mv ohSongcast-${sha_songcast} openhome/ohSongcast || die "Couldn't mv ohSongcast"

	cd "${WORKDIR}/openhome/ohNet" || die "Couldn't cd to ohNet dir"
	epatch "${FILESDIR}/ohnet.makefile.patch"
	epatch "${FILESDIR}/ohnet.optionparser.patch"
	sed -i -e 's/ bundle-after-build//' UserTargets.mak || die "Couldn't patch UserTargets.mak"

	cd "${WORKDIR}/openhome/ohNetGenerated" || die "Couldn't cd to ohNetGenerated dir"
	epatch "${FILESDIR}/ohnetgenerated.makefile.patch"
	epatch "${FILESDIR}/ohnetgenerated.commonmk.patch"
	sed -i -e 's/ bundle-after-build//' UserTargets.mak \
		|| die "Couldn't patch generated UserTargets.mak"

	eapply_user
}

src_configure() {
	econf "--with-openhome=${WORKDIR}/openhome"
}

src_compile() {
	# Begin ohbuild.sh reverse engineer

	cd "${WORKDIR}/openhome/ohNet" || die "Couldn't cd to ohNet dir"
	make native_only=yes || die "ohnet make failed"

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

	cd "${WORKDIR}/openhome/ohTopology" || die "Couldn't cd to ohTopology dir"
	mkdir -p build/Include/OpenHome/Av || die "Couldn't mkdir av"
	cp -p OpenHome/Av/*.h build/Include/OpenHome/Av/ || die "Couldn't cp to av"

	cd "${WORKDIR}/openhome/ohSongcast" || die "Couldn't cd to ohSongcast dir"
	make release=1 Receiver WavSender || die "Failed to build ohSongcast"

	# End ohbuild.sh reverse engineer

	cd "${S}" || die "Failed to cd to source directory"
	make || die "Failed to make sc2mpd"
}
