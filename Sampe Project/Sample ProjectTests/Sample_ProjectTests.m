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

- (void)testDanishLocalization {
    [_harpy setForceLanguageLocalization:HarpyLanguageDanish];

    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update Available"] isEqualToString:@"Tilgængelig opdatering"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Next time"] isEqualToString:@"Næste gang"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Skip this version"] isEqualToString:@"Spring denne version over"]);
    XCTAssertTrue([[_harpy testLocalizedStringForKey:@"Update"] isEqualToString:@"Opdater"]);
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

@end
