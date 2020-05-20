# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="avantgar bookman charter cm-super cmextra courier euro euro-ce eurosym fpl helvetic lm lm-math marvosym mathpazo manfnt-font mflogo-font ncntrsbk palatino pxfonts rsfs symbol tex-gyre tex-gyre-math times tipa txfonts utopia wasy wasy-type1 wasysym zapfchan zapfding collection-fontsrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="charter.doc cm-super.doc euro.doc euro-ce.doc eurosym.doc fpl.doc lm.doc lm-math.doc marvosym.doc mathpazo.doc mflogo-font.doc pxfonts.doc rsfs.doc tex-gyre.doc tex-gyre-math.doc tipa.doc txfonts.doc utopia.doc wasy.doc wasy-type1.doc wasysym.doc "
TEXLIVE_MODULE_SRC_CONTENTS="euro.source fpl.source lm.source marvosym.source mathpazo.source tex-gyre.source tex-gyre-math.source wasysym.source "
inherit  texlive-module
DESCRIPTION="TeXLive Recommended fonts"

LICENSE=" BSD GPL-1 GPL-2 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} "
