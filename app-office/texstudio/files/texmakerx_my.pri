CONFIG   += link_pkgconfig

# System Quazip
INCLUDEPATH += @GENTOO_PORTAGE_EPREFIX@/usr/include/quazip
LIBS += -lquazip
#INCLUDEPATH += @GENTOO_PORTAGE_EPREFIX@/usr/include/qt4/QCodeEdit
#INCLUDEPATH += @GENTOO_PORTAGE_EPREFIX@/usr/include/qt4/QtSolutions

# System hunspell
PKGCONFIG += hunspell

# System qtsingleapplication
#QT += solutions
CONFIG += qtsingleapplication

# System qcodeedit
# Not working currently
#CONFIG += qcodeedit
