# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

FPCVER="3.0.4"

DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi"
HOMEPAGE="https://www.lazarus-ide.org/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/Lazarus%20Zip%20_%20GZip/Lazarus%20${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
SLOT="0" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

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
		"${S}" "${ED}"/usr/share \
		|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../share/lazarus/startlazarus /usr/bin/lazarus
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	use minimal || dosym ../share/lazarus/components/chmhelp/lhelp/lhelp /usr/bin/lhelp
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus"
}
