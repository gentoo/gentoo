# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

FPCVER="3.0.4"
PYTHON_HASH="586eec1a5ea609ef9df2bf586be06825d9fbd50f"

DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi"
HOMEPAGE="https://www.lazarus-ide.org/"
SRC_URI="
	python? ( https://github.com/Alexey-T/Python-for-Lazarus/archive/${PYTHON_HASH}.tar.gz ->\
		${P}-python.tar.gz )
	https://sourceforge.net/projects/${PN}/files/Lazarus%20Zip%20_%20GZip/Lazarus%20${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
SLOT="0" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
KEYWORDS="~amd64 ~x86"
IUSE="minimal python"

DEPEND=">=dev-lang/fpc-${FPCVER}[source]
	net-misc/rsync
	x11-libs/gtk+:2
	>=sys-devel/binutils-2.19.1-r1:="
RDEPEND="${DEPEND}"

RESTRICT="strip" #269221

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-0.9.26-fpcsrc.patch )

src_prepare() {
	default
	# Use default configuration (minus stripping) unless specifically requested otherwise
	if ! test ${PPC_CONFIG_PATH+set} ; then
		local FPCVER=$(fpc -iV)
		export PPC_CONFIG_PATH="${WORKDIR}"
		sed -e 's/^FPBIN=/#&/' /usr/lib/fpc/${FPCVER}/samplecfg |
			sh -s /usr/lib/fpc/${FPCVER} "${PPC_CONFIG_PATH}" || die
	fi
	sed -i \
		-e "s;SecondaryConfigPath:='/etc/lazarus';SecondaryConfigPath:=ExpandFileNameUTF8('~/.lazarus');g" \
		-e "s;PrimaryConfigPath:=ExpandFileNameUTF8('~/.lazarus');PrimaryConfigPath:='/etc/lazarus';g" \
		ide/include/unix/lazbaseconf.inc \
		|| die
}

src_compile() {
	LCL_PLATFORM=gtk2 emake \
		$(usex minimal "" "bigide") \
		-j1
	if use python; then
		addpredict ide/exttools.pas
		./lazbuild -B --lazarusdir="." --pcp="../lazarus-package-config" --build-ide= \
			--add-package ../Python-for-Lazarus-${PYTHON_HASH}/python4lazarus/python4lazarus_package.lpk \
			|| die
		sed -i -e "s:${WORKDIR}/Python-for-Lazarus-${PYTHON_HASH}:/etc/lazarus:g" \
			../lazarus-package-config/packagefiles.xml \
			../lazarus-package-config/idemake.cfg \
			../Python-for-Lazarus-${PYTHON_HASH}/python4lazarus/lib/x86_64-linux/python4lazarus_package.compiled \
			|| die
		sed -i -e "s:${WORKDIR}/lazarus-package-config:/etc/lazarus:g" \
			../lazarus-package-config/idemake.cfg \
			|| die
	fi
}

src_install() {
	diropts -m0755
	dodir /usr/share
	# Using rsync to avoid unnecessary copies and cleaning...
	# Note: *.o and *.ppu are needed
	rsync -a \
		--exclude="CVS"     --exclude=".cvsignore" \
		--exclude="*.ppw"   --exclude="*.ppl" \
		--exclude="*.ow"    --exclude="*.a"\
		--exclude="*.rst"   --exclude=".#*" \
		--exclude="*.~*"    --exclude="*.bak" \
		--exclude="*.orig"  --exclude="*.rej" \
		--exclude=".xvpics" --exclude="*.compiled" \
		--exclude="killme*" --exclude=".gdb_hist*" \
		--exclude="debian"  --exclude="COPYING*" \
		--exclude="*.app" \
		"${S}" "${ED%/}"/usr/share \
		|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../share/lazarus/startlazarus /usr/bin/lazarus
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	use minimal || dosym ../share/lazarus/components/chmhelp/lhelp/lhelp /usr/bin/lhelp
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	if use python; then
		diropts -m0755
		dodir /etc/lazarus
		cp -rf ../lazarus-package-config/* \
			"${ED%/}"/etc/lazarus || die
		cp -rf ../Python-for-Lazarus-${PYTHON_HASH}/python4lazarus \
			"${ED%/}"/etc/lazarus || die
	fi

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus"
}
