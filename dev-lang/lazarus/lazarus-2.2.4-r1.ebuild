# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

# See https://wiki.freepascal.org/Lazarus_2.0_fixes_branch for notes and
# changes in FPCVER. It *does* change between minor versions of lazarus.
FPCVER="3.2.2"

DESCRIPTION="feature rich visual programming environment emulating Delphi"
HOMEPAGE="https://www.lazarus-ide.org/"
SRC_URI="mirror://sourceforge/lazarus/${P}-0.tar.gz https://dev.gentoo.org/~amynka/snap/${P}-makefile.patch.bz2"

LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
SLOT="0/2.2" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
KEYWORDS="~amd64 ~x86"
IUSE="gtk2 +gui extras"
REQUIRED_USE="gtk2? ( gui ) extras? ( gui )"

# Pascal ignores CFLAGS and does its own stripping. Nothing else can be done about it.
QA_FLAGS_IGNORED="
/usr/share/lazarus/startlazarus \
/usr/share/lazarus/lazarus \
/usr/share/lazarus/tools/lazres \
/usr/share/lazarus/tools/lrstolfm \
/usr/share/lazarus/tools/updatepofiles \
/usr/share/lazarus/tools/svn2revisioninc \
/usr/share/lazarus/lazbuild \
/usr/share/lazarus/components/chmhelp/lhelp/lhelp"

QA_PRESTRIPPED=${QA_FLAGS_IGNORED}

DEPEND="
	>=dev-lang/fpc-${FPCVER}[source]
	>=sys-devel/binutils-2.19.1-r1:=
	gui? (
	    !gtk2? ( dev-libs/libqt5pas:0/2.2 )
	    gtk2? ( x11-libs/gtk+:2 )
)"
BDEPEND="net-misc/rsync"
RDEPEND="${DEPEND}"

RESTRICT="strip" #269221

S="${WORKDIR}/${PN}"

PATCHES=(
	"${WORKDIR}/${P}"-makefile.patch
	"${FILESDIR}"/${PN}-0.9.26-fpcsrc.patch )

src_prepare() {
	default
	# Use default configuration (minus stripping) unless specifically requested otherwise
	if ! test ${PPC_CONFIG_PATH+set} ; then
		local FPCVER=$(fpc -iV)
		export PPC_CONFIG_PATH="${WORKDIR}"
		sed -e 's/^FPBIN=/#&/' /usr/lib/fpc/${FPCVER}/samplecfg |
			sh -s /usr/lib/fpc/${FPCVER} "${PPC_CONFIG_PATH}" || die
	fi
}

src_compile() {
	# TODO: Change to LCL_PLATFORM=qt5?
	# bug #732758
	if ( use gui ) && ( use !gtk2 ) ; then
		export LCL_PLATFORM=qt5
	fi
	use gtk2 && export LCL_PLATFORM=gtk2
	if ( use gui ) ; then
		emake all $(usex extras "bigide lhelp" "") -j1 || die "make failed!"
	else
		emake lazbuild -j1 || die "make failed!"
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
		"${S}" "${ED}"/usr/share \
		|| die "Unable to copy files!"

	if ( use gui ) ; then
		dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
		dosym ../share/lazarus/startlazarus /usr/bin/lazarus
	fi
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	use extras && dosym ../share/lazarus/components/chmhelp/lhelp/lhelp /usr/bin/lhelp
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	use gui && make_desktop_entry startlazarus "Lazarus IDE" "lazarus"
}
