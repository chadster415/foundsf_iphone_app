//
// XMLReader.h: http://troybrant.net/blog/2010/09/simple-xml-to-nsdictionary-converter/
//
#import <Foundation/Foundation.h>

@class Constants; 
@class ApiResponse; 

@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError **errorPointer;
	ApiResponse *apiResponse; // Instance of our model object
}

@property (nonatomic, retain) ApiResponse *apiResponse;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
- (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;
- (BOOL)parse: (NSString *) apiUrl;
- (id)initWithApiResponse:(ApiResponse *)apiResponse; // Custom initializer

@end
