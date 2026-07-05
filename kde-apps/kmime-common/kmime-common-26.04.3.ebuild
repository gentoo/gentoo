# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_I18N="false"
ECM_HANDBOOK="false"
KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	!<${CATEGORY}/${KDE_ORG_NAME}-26.04.1-r1:*
	!=${CATEGORY}/${KDE_ORG_NAME}-26.04.2-r0:*
"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=()

ecm-common_inject_heredoc() {
	cat >> CMakeLists.txt <<- _EOF_ || die
		include(ECMPoQmTools)
		include(ECMQtDeclareLoggingCategory)
		add_subdirectory(src)
		ecm_install_po_files_as_qm(poqm)
	_EOF_
	cat > src/CMakeLists.txt <<- _EOF_ || die
		set(KPim6Mime_SRCS
			charfreq.cpp
			util.cpp
			util_p.cpp
			mdn.cpp
			parsers.cpp
			headerparsing.cpp
			headerfactory.cpp
			content.cpp
			contentindex.cpp
			headers.cpp
			message.cpp
			newsarticle.cpp
			codecs.cpp
			types.cpp

			charfreq_p.h
			util.h
			mdn.h
			parsers_p.h
			headerparsing.h
			headerparsing_p.h
			headerfactory_p.h
			content.h
			contentindex.h
			headers.h
			message.h
			newsarticle.h
			codecs_p.h
			types.h
		)
		ecm_qt_declare_logging_category(KPim6Mime_SRCS
			HEADER kmime_debug.h
			IDENTIFIER KMIME_LOG
			CATEGORY_NAME org.kde.pim.kmime
			DESCRIPTION "kmime (pim lib)" EXPORT KMIME)
		ecm_qt_install_logging_categories(EXPORT KMIME FILE kmime.categories DESTINATION \${KDE_INSTALL_LOGGINGCATEGORIESDIR})
	_EOF_
}
