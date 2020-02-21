# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="mkclean is a command line tool to clean and optimize Matroska files"
HOMEPAGE="http://www.matroska.org/downloads/mkclean.html"
SRC_URI="http://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	tc-export CC CXX

	emake -C corec/tools/coremake
	mv corec/tools/coremake/coremake . || die

	./coremake $(corec/tools/coremake/system_output.sh) || die

	# fixing generated makefiles
	local f
	while IFS="" read -d $'\0' -r f; do
		sed \
			-e 's|^\(LFLAGS.*+=.*\$(LIBS)\)|\1 \$(LDFLAGS)|g' \
			-e 's|^\(STRIP.*=\)|\1 echo|g' \
			-i "${f}" || die
	done < <(find -name "*.mak" -type f -print0)
}

src_compile() {
	emake -f GNUmakefile -j1
	emake -C mkclean -f mkWDclean.mak -j1
	emake -C mkclean/regression -f mkcleanreg.mak -j1
}

src_install() {
	dobin release/*/mk*clean*
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
