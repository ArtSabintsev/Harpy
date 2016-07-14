//
//  Sample_ProjectTests.m
//  Sample ProjectTests
//
//  Created by Sabintsev, Arthur on 7/13/16.
//  Copyright © 2016 Arthur Ariel Sabintsev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Harpy.h"

@interface Sample_ProjectTests : XCTestCase

@property (nonatomic, strong) Harpy *harpy;

@end

@implementation Sample_ProjectTests

- (void)setUp {
    [super setUp];

    _harpy = [Harpy sharedInstance];
}


- (void)testArabicLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageArabic];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"التجديد متوفر"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"المرة التالية"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"تخطى عن هذه النسخة"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"تجديد"]);
}

- (void)testArmenianLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageArmenian];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Թարմացումը հասանելի Է"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Հաջորդ անգամ"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Բաց թողնել այս տարբերակը"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Թարմացնել"]);
}

- (void)testBasqueLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageBasque];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Eguneratzea erabilgarri"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Hurrengo batean"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Bertsio honetatik jauzi egin"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Eguneratu"]);
}

- (void)testCroationLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageCroatian];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Nova ažuriranje je stigla"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Sljedeći put"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Preskoči ovu verziju"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Ažuriraj"]);
}

- (void)testDanishLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageDanish];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Tilgængelig opdatering"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Næste gang"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Spring denne version over"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Opdater"]);
}

- (void)testFrenchLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageFrench];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Mise à jour disponible"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"La prochaine fois"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Sauter cette version"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Mettre à jour"]);
}

- (void)testGermanLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageGerman];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Update erhältlich"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Später"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Diese Version überspringen"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Update"]);
}

- (void)testEnglishLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageEnglish];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Update Available"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Next time"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Skip this version"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Update"]);
}

- (void)testEstonianLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageEstonian];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Uuendus saadaval"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Järgmisel korral"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Jäta see version vahele"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Uuenda"]);
}

- (void)testHebrewLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageHebrew];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"עדכון זמין"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"בפעם הבאה"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"דלג על גרסה זו"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"עדכן"]);
}

- (void)testHungarianLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageHungarian];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Új frissítés érhető el"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Később"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Ennél a verziónál ne figyelmeztessen"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Frissítés"]);
}

- (void)testItalianLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageItalian];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Aggiornamento disponibile"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"La prossima volta"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Salta questa versione"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Aggiorna"]);
}

- (void)testJapaneseLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageJapanese];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"更新が利用可能"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"次回"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"このバージョンをスキップ"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"更新"]);
}

- (void)testSpanishLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageSpanish];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Actualización disponible"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"La próxima vez"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Saltar esta versión"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Actualizar"]);
}

@end
