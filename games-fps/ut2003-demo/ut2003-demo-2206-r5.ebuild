# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

DESCRIPTION="Demo for the sequel to the 1999 multi-player first-person shooter"
HOMEPAGE="http://www.ut2003.com/"
SRC_URI="http://unreal.epicgames.com/linux/ut2003/ut2003demo-lnx-${PV}.sh.bin
	http://download.factoryunreal.com/mirror/UT2003CrashFix.zip
	https://dev.gentoo.org/~wolf31o2/sources/${PN}/${PN}-misc.tar.bz2"
S="${WORKDIR}"

LICENSE="ut2003-demo"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="app-arch/unzip"
RDEPEND="
	sys-devel/bc
	sys-libs/libstdc++-v3:5
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
"

dir=opt/${PN}
Ddir="${ED}"/${dir}

QA_PREBUILT="${dir}/*.so ${dir}/*-bin ${dir}/System/libSDL-1.2.so.0"

src_unpack() {
	unpack_makeself "${DISTDIR}"/ut2003demo-lnx-${PV}.sh.bin || die
	unzip "${DISTDIR}"/UT2003CrashFix.zip || die

	cd "${S}" || die
	unpack ./setupstuff.tar.gz || die
	unpack ./ut2003lnx_demo.tar.bz2 || die
	unpack ${PN}-misc.tar.bz2 || die
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"
	dodir "${dir}"

	local i
	for i in Animations Benchmark Help KarmaData Maps Music Sounds \
			StaticMeshes System Textures Web extras ; do
		dodir "${dir}"/${i}
		cp -pPR "${S}"/${i}/* "${Ddir}"/${i} || die
	done

	# Fix the benchmark configurations to use SDL rather than the Windows driver
	local f
	for f in MaxDetail.ini MinDetail.ini ; do
		sed -i \
			-e 's/RenderDevice=D3DDrv.D3DRenderDevice/\;RenderDevice=D3DDrv.D3DRenderDevice/' \
			-e 's/ViewportManager=WinDrv.WindowsClient/\;ViewportManager=WinDrv.WindowsClient/' \
			-e 's/\;RenderDevice=OpenGLDrv.OpenGLRenderDevice/RenderDevice=OpenGLDrv.OpenGLRenderDevice/' \
			-e 's/\;ViewportManager=SDLDrv.SDLClient/ViewportManager=SDLDrv.SDLClient/' \
			"${Ddir}"/Benchmark/Stuff/${f} || die
	done

	# Have the benchmarks run the nifty wrapper script rather than
	# ../System/ut2003-bin directly
	for f in "${Ddir}"/Benchmark/*-*.sh ; do
		sed -i \
			-e 's:\.\./System/ut2003-bin:../ut2003_demo:' "${f}" || die
	done

	# Wrapper and benchmark-scripts
	dobin "${FILESDIR}"/ut2003-demo
	exeinto "${dir}"/Benchmark
	doexe "${FILESDIR}/"{benchmark,results.sh}
	sed -i \
		-e "s:GAMES_PREFIX_OPT:/opt:" \
		"${ED}/usr/bin/${PN}" \
		"${ED}/${dir}"/Benchmark/benchmark || die

	# Here we apply DrSiN's crash patch
	cp "${S}"/CrashFix/System/crashfix.u "${Ddir}"/System || die

ed "${Ddir}"/System/Default.ini >/dev/null 2>&1 <<EOT
$
?Engine.GameInfo?
a
AccessControlClass=crashfix.iaccesscontrolini
.
w
q
EOT

	exeinto "${dir}"
	insinto "${dir}"
	doins DemoLicense.int README.linux
	doexe ucc ut2003_demo
	newicon Unreal.xpm ut2003-demo.xpm
	make_desktop_entry ut2003-demo "Unreal Tournament 2003 (Demo)" ${PN}
}

pkg_postinst() {
	elog "You can run benchmarks by typing 'ut2003-demo --bench' (MinDetail seems"
	elog "to not be working for some unknown reason :/)"

	echo
	elog "Read ${dir}/README.linux for instructions on how to run a"
	elog "dedicated server."

	echo
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003demo/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."

	echo
	elog "To play the demo run:"
	elog " ut2003-demo"

	echo
}
