# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

MY_PN=${PN/jif/JIF}
MY_PV=${PV/rc/RC}
MY_PV=${MY_PV/./}
MY_PV_MAJOR=${MY_PV/_*/}
MY_PV_MINOR=${MY_PV/*_/}
MY_P=${MY_PN}${MY_PV_MAJOR}_src_${MY_PV_MINOR}

IUSE=""

DESCRIPTION="JIF is an IDE for the creation of text adventures based on Graham Nelson's Inform standard"
HOMEPAGE="http://www.slade.altervista.org/JIF/"
SRC_URI="http://www.slade.altervista.org/downloads/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND=">=virtual/jdk-1.4
	>=sys-apps/sed-4.1.4
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.4
	>=dev-lang/inform-6.21.4
	>=games-engines/gargoyle-2010.1"

S=${WORKDIR}/src

src_compile()
{
	# Compile classes just as it is done upstream
	javac -source 1.4 -O -classpath . *.java

	# Adapt default Jif.cfg file to Gentoo
	sed -i -e "s:\[EXECUTE\]e\,explorer.exe:#\[EXECUTE\]e\,explorer.exe:" Jif.cfg
	sed -i -e "s:\[EXECUTE\]d\,hh.exe\ C\:\\\Jif\\\doc\\\prova.chm:#\[EXECUTE\]d\,hh.exe\ C\:\\\Jif\\\doc\\\prova.chm:" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Lib\\\Base:/usr/share/inform/6.21/module:" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Lib\\\Contrib::" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Games::" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Bin\\\interpreter\\\Frotz\\\Frotz.exe:/usr/games/bin/frotz:" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Bin\\\interpreter\\\Gargoyle\\\Gargoyle.exe:/usr/bin/gargoyle:" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Bin\\\compiler\\\inform.exe:/usr/bin/inform:" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Bin\\\tools\\\Blorb\\\bres.exe::" Jif.cfg
	sed -i -e "s:C\:\\\Inform\\\Bin\\\tools\\\Blorb\\\blc.exe::" Jif.cfg
	sed -i -e "s:Italian,on:Italian,off:" Jif.cfg
	sed -i -e "s:English,off:English,on:" Jif.cfg

	# Pack them as upstream
	jar cvfm Jif.jar MANIFEST.MF *.class *.properties images/*.png readme.txt Jif.cfg
}

src_install()
{
	java-pkg_dojar Jif.jar
	dobin "${FILESDIR}"/jif
	dodoc CHANGELOG.txt readme.txt
}
