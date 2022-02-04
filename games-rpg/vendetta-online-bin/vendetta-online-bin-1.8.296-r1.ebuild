# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

DESCRIPTION="Space-based MMORPG"
HOMEPAGE="https://www.vendetta-online.com"
SRC_URI="
	amd64? (
		http://mirror.cle.vendetta-online.com/vendetta-linux-amd64-installer.sh
			-> ${P}-amd64.sh
	)
	x86? (
		http://mirror.cle.vendetta-online.com/vendetta-linux-ia32-installer.sh
			-> ${P}-x86.sh
	)
"
S="${WORKDIR}"

LICENSE="guild"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror strip"

RDEPEND="
	media-libs/alsa-lib
	media-sound/pulseaudio
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:2
"
BDEPEND="dev-util/patchelf"

QA_FLAGS_IGNORED="
	opt/vendetta-online-bin/install/drivers/.*.so
	opt/vendetta-online-bin/install/update.rlb
	opt/vendetta-online-bin/install/vendetta
	opt/vendetta-online-bin/vendetta
"

src_unpack() {
	unpack_makeself
}

src_prepare() {
	# Won't do much good since this is a -bin, but there's no bin_prepare :)
	default

	# scanelf: rpath_security_checks(): Security problem with relative DT_RPATH '.'
	for file in install/drivers/{gkvc.so,soundbackends/libalsa_linux_amd64.so,soundbackends/libpulseaudio_linux_amd64.so} ; do
		patchelf --set-rpath '$ORIGIN' $file || die
	done
}

src_install() {
	local dir=/opt/${PN}

	insinto ${dir}
	doins -r *
	fperms +x ${dir}/{vendetta,install/{media.rlb,update.rlb,vendetta}}

	sed \
		-e "s:DATADIR:${dir}:" \
		"${FILESDIR}"/vendetta > "${T}"/vendetta \
		|| die "sed failed"

	dobin "${T}"/vendetta
	newicon install/manual/images/ships.valkyrie.jpg ${PN}.jpg
	make_desktop_entry vendetta "Vendetta Online" /usr/share/pixmaps/${PN}.jpg
}
