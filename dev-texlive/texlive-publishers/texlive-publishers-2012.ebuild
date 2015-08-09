# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="IEEEconf IEEEtran aastex acmconf active-conf adfathesis afthesis aguplus aiaa ametsoc anufinalexam aomart apa apa6 apa6e arsclassica articleingud asaetr ascelike beamer-FUBerlin bgteubner cascadilla chem-journal classicthesis cmpj confproc ebsthesis economic ejpecp elbioimp elsarticle elteikthesis erdc estcpmm fbithesis fcltxdoc gaceta gatech-thesis har2nat hobete icsv ieeepes ijmart imac imsproc imtekda jmlr jpsj kdgdocs kluwer lps macqassign mentis msu-thesis musuos muthesis nature nddiss nih nostarch nrc onrannual philosophersimprint powerdot-FUBerlin pracjourn procIAGssymp ptptex psu-thesis revtex revtex4 ryethesis sageep sapthesis seuthesis soton spie stellenbosch suftesi sugconf texilikechaps texilikecover thesis-titlepage-fhac thuthesis toptesi tugboat tugboat-plain tui uaclasses uafthesis ucdavisthesis ucthesis uiucthesis umthesis umich-thesis unamthesis ut-thesis uothesis uowthesis uwthesis vancouver york-thesis collection-publishers
"
TEXLIVE_MODULE_DOC_CONTENTS="IEEEconf.doc IEEEtran.doc aastex.doc acmconf.doc active-conf.doc adfathesis.doc afthesis.doc aguplus.doc aiaa.doc ametsoc.doc anufinalexam.doc aomart.doc apa.doc apa6.doc apa6e.doc arsclassica.doc articleingud.doc asaetr.doc ascelike.doc beamer-FUBerlin.doc bgteubner.doc cascadilla.doc classicthesis.doc cmpj.doc confproc.doc ebsthesis.doc economic.doc ejpecp.doc elbioimp.doc elsarticle.doc elteikthesis.doc erdc.doc estcpmm.doc fbithesis.doc fcltxdoc.doc gaceta.doc gatech-thesis.doc har2nat.doc hobete.doc icsv.doc ieeepes.doc ijmart.doc imac.doc imsproc.doc imtekda.doc jmlr.doc jpsj.doc kdgdocs.doc kluwer.doc lps.doc macqassign.doc mentis.doc msu-thesis.doc musuos.doc muthesis.doc nature.doc nddiss.doc nih.doc nostarch.doc nrc.doc onrannual.doc philosophersimprint.doc powerdot-FUBerlin.doc pracjourn.doc procIAGssymp.doc ptptex.doc psu-thesis.doc revtex.doc revtex4.doc ryethesis.doc sageep.doc sapthesis.doc seuthesis.doc soton.doc spie.doc stellenbosch.doc suftesi.doc sugconf.doc thesis-titlepage-fhac.doc thuthesis.doc toptesi.doc tugboat.doc tugboat-plain.doc tui.doc uaclasses.doc uafthesis.doc ucdavisthesis.doc ucthesis.doc uiucthesis.doc umthesis.doc umich-thesis.doc unamthesis.doc ut-thesis.doc uothesis.doc uowthesis.doc uwthesis.doc vancouver.doc york-thesis.doc "
TEXLIVE_MODULE_SRC_CONTENTS="IEEEconf.source aastex.source acmconf.source active-conf.source adfathesis.source aiaa.source aomart.source apa6.source apa6e.source articleingud.source bgteubner.source confproc.source ebsthesis.source ejpecp.source elbioimp.source elsarticle.source elteikthesis.source erdc.source estcpmm.source fbithesis.source fcltxdoc.source icsv.source ijmart.source imtekda.source jmlr.source kdgdocs.source kluwer.source lps.source mentis.source musuos.source nddiss.source nostarch.source nrc.source philosophersimprint.source pracjourn.source revtex.source revtex4.source ryethesis.source sageep.source seuthesis.source stellenbosch.source suftesi.source thesis-titlepage-fhac.source thuthesis.source toptesi.source tugboat.source uaclasses.source ucdavisthesis.source uiucthesis.source uothesis.source york-thesis.source "
inherit  texlive-module
DESCRIPTION="TeXLive Support for publishers, theses, standards, conferences, etc."

LICENSE="GPL-2 Apache-2.0 GPL-1 GPL-3 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2012
!<dev-texlive/texlive-latexextra-2011
"
RDEPEND="${DEPEND} "
